Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3ANJnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:43:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098Ab3ANJni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:43:38 -0500
Date: Mon, 14 Jan 2013 10:43:25 +0100
From: Borislav Petkov <bp@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
Message-ID: <20130114094325.GC1228@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
	Matt Fleming <matt.fleming@intel.com>,
	Gokul Caushik <caushik1@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Joe Millenbach <jmillenbach@gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-23-git-send-email-yinghai@kernel.org>
 <20130113214132.GB17200@liondog.tnic>
 <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 09:37:08PM -0800, Yinghai Lu wrote:
> > Question: if the bootloader sets ext_* properly, is it going to set
> > sentinel to 0 so that it can signal to the code further on that ext_*
> > are valid?
> 
> old bootloaders have no idea of sentinel, but if they initialize boot_param
> properly that new sentinel will be 0 and new kernel will know.
> 
> >
> > This is kinda missing from the mechanism of the sentinel and it should
> > be documented too.
> 
> No, we should have too much duplicated info.

This is not a complicated info - it should explain the basic mechanism
of the sentinel.

> >> -v7: change to 0x1ef instead of 0x1f0, HPA said:
> >>       it is quite plausible that someone may (fairly sanely) start the
> >>       copy range at 0x1f0 instead of 0x1f1
> >
> > Right, all those -vX notes are all important and should *definitely* be
> > at least in the commit message.
> 
> No, I want to keep them in order to track the reviewing progress.

Are you saying "no" just for the fun of it? Or do you have a general
aversion to documenting your code?

Give me *one* good reason where having a short, concise and clear
comment which helps people understand what the intent of the mechanism
is a bad thing.

[ … ]

> >> diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
> >> index b4c913c..bffd73b 100644
> >> --- a/arch/x86/boot/compressed/cmdline.c
> >> +++ b/arch/x86/boot/compressed/cmdline.c
> >> @@ -17,6 +17,8 @@ static unsigned long get_cmd_line_ptr(void)
> >>  {
> >>       unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
> >>
> >> +     cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
> >> +
> >>       return cmd_line_ptr;
> >>  }
> >
> > On 32-bit, this unsigned long cmd_line_ptr is 4 bytes and the OR doesn't
> > have any effect on the final result. You probably want to do:
> 
> yes, that is what we want to keep 32bit and 64bit unified.
> 
> >
> > #ifdef CONFIG_64BIT
> >         cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
> > #endif
> >
> > right?
> >
> > Or instead look at ->sentinel to know whether the ext_* fields are valid
> > or not, and save yourself the OR if not.
> 
> no.
> 
> that is whole point of sentinel, we don't need to check sentinel everywhere
> because ext_* are valid.

Dude, do you even read my comments? This line:

	cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;

doesn't do a whit on 32-bit. So execute it *only* on 32-bit!

[ … ]

> >> diff --git a/arch/x86/boot/setup.ld b/arch/x86/boot/setup.ld
> >> index 03c0683..9333d37 100644
> >> --- a/arch/x86/boot/setup.ld
> >> +++ b/arch/x86/boot/setup.ld
> >> @@ -13,6 +13,13 @@ SECTIONS
> >>       .bstext         : { *(.bstext) }
> >>       .bsdata         : { *(.bsdata) }
> >>
> >> +     /* sentinel: make sure if boot_params from bootloader is right */
> >
> > This should say:
> >
> >         /*
> >          * The bootloader signals the validity of the three ext_* boot params with this.
> >          */
> 
> no, bootloader does not signal that.
> old bootloaders have no idea of sentinel, but if they initialize boot_param
> properly that new sentinel will be 0 and new kernel will know.

So say

	 * A RECENT bootloader signals the validity of the three ext_* boot params with this.

but say something.

Understand this (and we've been chewing this same shit for two weeks
now): you need to document your code and you need to document it
properly for other people to understand what you're doing. I'm not
talking about writing an essay or whatever - I'm talking about helpful
comments placed where it makes most sense so that others can understand
the mechanism.

[ … ]

> >> +     __u16   xloadflags;
> >> +#define CAN_BE_LOADED_ABOVE_4G       (1<<0)
> >>       __u32   cmdline_size;
> >>       __u32   hardware_subarch;
> >>       __u64   hardware_subarch_data;
> >> @@ -106,7 +108,10 @@ struct boot_params {
> >>       __u8  hd1_info[16];     /* obsolete! */         /* 0x090 */
> >>       struct sys_desc_table sys_desc_table;           /* 0x0a0 */
> >>       struct olpc_ofw_header olpc_ofw_header;         /* 0x0b0 */
> >> -     __u8  _pad4[128];                               /* 0x0c0 */
> >> +     __u32 ext_ramdisk_image;                        /* 0x0c0 */
> >> +     __u32 ext_ramdisk_size;                         /* 0x0c4 */
> >> +     __u32 ext_cmd_line_ptr;                         /* 0x0c8 */
> >> +     __u8  _pad4[116];                               /* 0x0cc */
> >>       struct edid_info edid_info;                     /* 0x140 */
> >>       struct efi_info efi_info;                       /* 0x1c0 */
> >>       __u32 alt_mem_k;                                /* 0x1e0 */
> >> @@ -115,7 +120,9 @@ struct boot_params {
> >>       __u8  eddbuf_entries;                           /* 0x1e9 */
> >>       __u8  edd_mbr_sig_buf_entries;                  /* 0x1ea */
> >>       __u8  kbd_status;                               /* 0x1eb */
> >> -     __u8  _pad6[5];                                 /* 0x1ec */
> >> +     __u8  _pad5[3];                                 /* 0x1ec */
> >> +     __u8  sentinel;                                 /* 0x1ef */
> >> +     __u8  _pad6[1];                                 /* 0x1f0 */
> >
> > This needs the -v7 explanation from above as a comment here or somewhere
> > around here, for why we've chosen 0x1ef offset.
> 
> no, there is no such comment for other fields there.

That's why I f*cking said "here or somewhere around here"! Or put
it somewhere else altogether, if you don't like it here but PUT IT
SOMEWHERE!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
