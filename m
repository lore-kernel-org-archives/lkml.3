Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529Ab3IDMBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:01:54 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41539 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3IDMBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:01:53 -0400
MIME-Version: 1.0
In-Reply-To: <1378291877.6380.74.camel@linux-s257.site>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	<1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
	<20130829183713.GT20828@hansolo.jdub.homelinux.org>
	<522104A6.5000700@zytor.com>
	<20130830234133.GR20828@hansolo.jdub.homelinux.org>
	<1378291877.6380.74.camel@linux-s257.site>
Date: Wed, 4 Sep 2013 08:01:52 -0400
X-Google-Sender-Auth: pvC_Yfosi_p3re4vk05b3rJWI-A
Message-ID: <CA+5PVA4J1mL0o=MHM-D81rcViR+E3JUyGChvHe8P+3+yt3v_qA@mail.gmail.com>
Subject: Re: [PATCH V2 10/10] Add option to automatically enforce module
 signatures when in Secure Boot mode
From: Josh Boyer <jwboyer@fedoraproject.org>
To: joeyli <jlee@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 6:51 AM, joeyli <jlee@suse.com> wrote:
> 於 五，2013-08-30 於 19:41 -0400，Josh Boyer 提到：
>> On Fri, Aug 30, 2013 at 01:46:30PM -0700, H. Peter Anvin wrote:
>> > On 08/29/2013 11:37 AM, Josh Boyer wrote:
>> > >>          setup_efi_pci(boot_params);
>> > >> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
>> > >> index c15ddaf..d35da96 100644
>> > >> --- a/arch/x86/include/uapi/asm/bootparam.h
>> > >> +++ b/arch/x86/include/uapi/asm/bootparam.h
>> > >> @@ -131,7 +131,8 @@ struct boot_params {
>> > >>          __u8  eddbuf_entries;                           /* 0x1e9 */
>> > >>          __u8  edd_mbr_sig_buf_entries;                  /* 0x1ea */
>> > >>          __u8  kbd_status;                               /* 0x1eb */
>> > >> -        __u8  _pad5[3];                                 /* 0x1ec */
>> > >> +        __u8  secure_boot;                              /* 0x1ec */
>> > >> +        __u8  _pad5[2];                                 /* 0x1ec */
>> > >>          /*
>> > >>           * The sentinel is set to a nonzero value (0xff) in header.S.
>> > >>           *
>> > >
>> > > You need to include the following chunk of code with this, otherwise the
>> > > secure_boot variable gets cleared.
>> > >
>> >
>> > Not really.
>> >
>> > There are three cases:
>> >
>> > 1. Boot stub only.  Here we do the right thing with the bootparams.
>> > 2. Boot loader bypasses the boot stub completely.  Here we MUST NOT do
>> >    what you suggest above.
>> > 3. Boot stub with a boot_params structure passed in.  Here we should
>> >    run sanitize_boot_params() (an inline for a reason) in the boot
>> >    stub, before we set the secure_boot field.  Once that is done, we
>> >    again don't need that modification.
>>
>> OK.  If 3 works, then great.  All I know is that Fedora has been
>> carrying the above hunk for months and it was missing in this patch set.
>> So when I went to test it, the patches didn't do anything because the
>> secure_boot field was getting cleared.
>>
>> I'm more than happy to try option 3, and I'll poke at it next week
>> unless someone beats me to it.
>>
>> josh
>
> The secure_boot field cleaned by sanitize_boot_params() when using grub2
> linuxefi to load efi stub kernel.
> I printed the boot_params->sentinel value, confirm this value is NOT 0
> when running grub2 linuxefi path, the entry point is efi_stub_entry.
>
> On the other hand,
> the sentinel value is 0 when direct run efi stub kernel in UEFI shell,
> the secure_boot field can keep.
>
> Does that mean grub2 should clean the sentinel value? or we move the get
> secure_boot value to efi_init()?

See V3 of this patch that Matthew sent yesterday.  It calls
sanitize_boot_params in efi_main before calling get_secure_boot.  I
tested that yesterday and it worked fine.

josh
