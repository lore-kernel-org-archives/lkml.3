Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab3DZItn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:49:43 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48856 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab3DZItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:49:41 -0400
Message-ID: <517A3FA0.8030702@intel.com>
Date: Fri, 26 Apr 2013 09:49:36 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 fixes for 3.9
References: <201304252144.r3PLihDe025383@terminus.zytor.com> <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com> <1366928604.9976.3.camel@x230> <CANN689EH-VyDefawtKdY=cVQNdZP1xN7cV4bDgXvYeniSCkvqA@mail.gmail.com> <5179B435.1000404@zytor.com> <CANN689EaFu32GKNj-U41ykGpNJekBL2=w92P1pSkETuKAffJDQ@mail.gmail.com> <517A28D7.3010707@intel.com> <CANN689F7c8UbxGEHyAOH+uwZxFf7VoQDmCM3Nv862s2b=21bQg@mail.gmail.com>
In-Reply-To: <CANN689F7c8UbxGEHyAOH+uwZxFf7VoQDmCM3Nv862s2b=21bQg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 08:43, Michel Lespinasse wrote:
> Still seeing the crash.
> 
> I went and compared the crash dump with the vmlinux disassembly; the
> issue is a NULL pointer dereference in list_for_each_entry_safe().
> list_empty() checks that the head node points to itself, but here the
> head node has NULL. I think this may be due to gsmi_init() being
> called before efivars_init(). Not sure what's the proper fix though.

Ohh... I see what you mean. The bug is in variable_is_present() because
it accesses __efivars directly, which a) isn't the struct efivars gsmi.c
uses and b) hasn't been initialised. Something like this might work.

---

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 182ce94..f4baa11 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1628,10 +1628,11 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
+static bool variable_is_present(struct efivars *efivars,
+				efi_char16_t *variable_name,
+				efi_guid_t *vendor)
 {
 	struct efivar_entry *entry, *n;
-	struct efivars *efivars = &__efivars;
 	unsigned long strsize1, strsize2;
 	bool found = false;
 
@@ -1703,8 +1704,8 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
 			if (status != EFI_SUCCESS) {
 				break;
 			} else {
-				if (!variable_is_present(variable_name,
-				    &vendor)) {
+				if (!variable_is_present(efivars,
+				    variable_name, &vendor)) {
 					found = true;
 					break;
 				}
@@ -2008,7 +2009,8 @@ int register_efivars(struct efivars *efivars,
 			 * we'll ever see a different variable name,
 			 * and may end up looping here forever.
 			 */
-			if (variable_is_present(variable_name, &vendor_guid)) {
+			if (variable_is_present(efivars, variable_name,
+						&vendor_guid)) {
 				dup_variable_bug(variable_name, &vendor_guid,
 						 variable_name_size);
 				status = EFI_NOT_FOUND;
