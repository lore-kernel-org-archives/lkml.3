Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3CETwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:52:31 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33632 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3CETwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:52:30 -0500
Date: Tue, 5 Mar 2013 13:52:29 -0600
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Robin Holt <holt@sgi.com>, hpa@sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11
 elilo.efi
Message-ID: <20130305195229.GS3438@sgi.com>
References: <20130228205206.GC3438@sgi.com>
 <512FC697.3090608@zytor.com>
 <20130228210910.GD3438@sgi.com>
 <512FC82B.40909@zytor.com>
 <CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com>
 <512FE3AE.4070903@zytor.com>
 <20130305081519.GA19165@sgi.com>
 <9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com>
 <CAE9FiQV2Wk+yiqR8FnNM_L-p1iQFxDwopRzFWTwm6VCkyrbuoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV2Wk+yiqR8FnNM_L-p1iQFxDwopRzFWTwm6VCkyrbuoQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That fixed it for me.

Can you help me understand why sentinel is non-zero?  It looks to me
like 3.14 allocates 16kB plus strlen of the command line, zeros it,
and then proceeds to fill in fields, some differing from what is in the
boot_params structure.  That said, it looks like the sentinel field
should remain 0.  I am still trying to understand, but if this patch
makes it in, I am happy.

Thanks,
Robin

On Tue, Mar 05, 2013 at 11:12:08AM -0800, Yinghai Lu wrote:
> On Tue, Mar 5, 2013 at 7:22 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Yes, please do the analysis I asked for.
> 
> it uses first 2 pages in bzImage to bootparams.
> 
> then update the fields with ===> X
> 
> struct boot_params {
>         struct screen_info screen_info;                 /* 0x000 */   ===> X
>         struct apm_bios_info apm_bios_info;             /* 0x040 */   ===> X
>         __u8  _pad2[4];                                 /* 0x054 */
>         __u64  tboot_addr;                              /* 0x058 */
>         struct ist_info ist_info;                       /* 0x060 */
>         __u8  _pad3[16];                                /* 0x070 */
>         __u8  hd0_info[16];     /* obsolete! */         /* 0x080 */   ===> X
>         __u8  hd1_info[16];     /* obsolete! */         /* 0x090 */   ===> X
>         struct sys_desc_table sys_desc_table;           /* 0x0a0 */   ===> X
>         struct olpc_ofw_header olpc_ofw_header;         /* 0x0b0 */
>         __u32 ext_ramdisk_image;                        /* 0x0c0 */
>         __u32 ext_ramdisk_size;                         /* 0x0c4 */
>         __u32 ext_cmd_line_ptr;                         /* 0x0c8 */
>         __u8  _pad4[116];                               /* 0x0cc */
>         struct edid_info edid_info;                     /* 0x140 */
>         struct efi_info efi_info;                       /* 0x1c0 */   ===> X
>         __u32 alt_mem_k;                                /* 0x1e0 */   ===> X
>         __u32 scratch;          /* Scratch field! */    /* 0x1e4 */
>         __u8  e820_entries;                             /* 0x1e8 */  ===> X
>         __u8  eddbuf_entries;                           /* 0x1e9 */
>         __u8  edd_mbr_sig_buf_entries;                  /* 0x1ea */
>         __u8  kbd_status;                               /* 0x1eb */
>         __u8  _pad5[3];                                 /* 0x1ec */
>         /*
>          * The sentinel is set to a nonzero value (0xff) in header.S.
>          *
>          * A bootloader is supposed to only take setup_header and put
>          * it into a clean boot_params buffer. If it turns out that
>          * it is clumsy or too generous with the buffer, it most
>          * probably will pick up the sentinel variable too. The fact
>          * that this variable then is still 0xff will let kernel
>          * know that some variables in boot_params are invalid and
>          * kernel should zero out certain portions of boot_params.
>          */
>         __u8  sentinel;                                 /* 0x1ef */
>         __u8  _pad6[1];                                 /* 0x1f0 */
>         struct setup_header hdr;    /* setup header */  /* 0x1f1 */  ===> X
>         __u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
>         __u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];      /* 0x290 */
>         struct e820entry e820_map[E820MAX];             /* 0x2d0 */  ===> X
>         __u8  _pad8[48];                                /* 0xcd0 */
>         struct edd_info eddbuf[EDDMAXNR];               /* 0xd00 */
>         __u8  _pad9[276];                               /* 0xeec */
> 
> so sentinel will be kept as 0xff, so efi_info get cleared by kernel...
> 
> Attached patches should avoid the clearing of efi_info when elilo is used.
> 
> Do we need to clear edd and pad2 and pad3 for elilo?
> 
> Thanks
> 
> Yinghai


