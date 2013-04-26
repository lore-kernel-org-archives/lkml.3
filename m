Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab3DZJoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:44:17 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:61614 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3DZJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:44:15 -0400
Message-ID: <517A4C6C.3090409@intel.com>
Date: Fri, 26 Apr 2013 10:44:12 +0100
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
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Mike Waychison <mikew@google.com>
Subject: Re: [GIT PULL] x86 fixes for 3.9
References: <201304252144.r3PLihDe025383@terminus.zytor.com> <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com> <1366928604.9976.3.camel@x230> <CANN689EH-VyDefawtKdY=cVQNdZP1xN7cV4bDgXvYeniSCkvqA@mail.gmail.com> <5179B435.1000404@zytor.com> <CANN689EaFu32GKNj-U41ykGpNJekBL2=w92P1pSkETuKAffJDQ@mail.gmail.com> <517A28D7.3010707@intel.com> <CANN689F7c8UbxGEHyAOH+uwZxFf7VoQDmCM3Nv862s2b=21bQg@mail.gmail.com> <517A3FA0.8030702@intel.com> <CANN689FWig4wVomOzQpSLYAdwuWVjrUZa5KNEDH2pieKCa0ceA@mail.gmail.com>
In-Reply-To: <CANN689FWig4wVomOzQpSLYAdwuWVjrUZa5KNEDH2pieKCa0ceA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 10:02, Michel Lespinasse wrote:
> On Fri, Apr 26, 2013 at 1:49 AM, Matt Fleming <matt.fleming@intel.com> wrote:
>> On 26/04/13 08:43, Michel Lespinasse wrote:
>>> Still seeing the crash.
>>>
>>> I went and compared the crash dump with the vmlinux disassembly; the
>>> issue is a NULL pointer dereference in list_for_each_entry_safe().
>>> list_empty() checks that the head node points to itself, but here the
>>> head node has NULL. I think this may be due to gsmi_init() being
>>> called before efivars_init(). Not sure what's the proper fix though.
>>
>> Ohh... I see what you mean. The bug is in variable_is_present() because
>> it accesses __efivars directly, which a) isn't the struct efivars gsmi.c
>> uses and b) hasn't been initialised. Something like this might work.
> 
> [... skipping patch ...]
> 
> Yes, this one fixes it. Thanks !

Thanks for testing!

Linus, did you want to take this one directly?

---

>From f576b789b29dab31ddc1c7d37af63f10fb203fb7 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Fri, 26 Apr 2013 10:10:55 +0100
Subject: [PATCH] efivars: only check for duplicates on the registered list

variable_is_present() accesses '__efivars' directly, but when called
via gsmi_init() Michel reports observing the following crash,

  BUG: unable to handle kernel NULL pointer dereference at (null)
  IP: [<ffffffff814a7245>] variable_is_present+0x55/0x170
  Call Trace:
  [<ffffffff814a9936>] register_efivars+0x106/0x370
  [<ffffffff818ff430>] ? firmware_map_add_early+0xb1/0xb1
  [<ffffffff818ff6dd>] gsmi_init+0x2ad/0x3da
  [<ffffffff8100020f>] do_one_initcall+0x3f/0x170

The reason for the crash is that '__efivars' hasn't been initialised nor
has it been registered with register_efivars() by the time the google
EFI SMI driver runs. The gsmi code uses its own struct efivars, and
therefore, a different variable list. Fix the above crash by passing the
registered struct efivars to variable_is_present(), so that we traverse
the correct list.

Reported-by: Michel Lespinasse <walken@google.com>
Tested-by: Michel Lespinasse <walken@google.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efivars.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

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
-- 
1.7.10.4

