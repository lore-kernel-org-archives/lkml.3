Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3ANTTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:19:39 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:41828 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab3ANTTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:19:38 -0500
MIME-Version: 1.0
In-Reply-To: <50F455A3.4070706@zytor.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-23-git-send-email-yinghai@kernel.org>
	<20130113214132.GB17200@liondog.tnic>
	<CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
	<50F4452D.2060000@zytor.com>
	<CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
	<50F455A3.4070706@zytor.com>
Date: Mon, 14 Jan 2013 11:19:36 -0800
X-Google-Sender-Auth: lWAIymKsRfwLKbLD5PiwrGSj9XA
Message-ID: <CAE9FiQXddeks1Dt4E15f7wcdQMumYJ+owoE7vZKShznMjgBG7A@mail.gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/14/2013 10:57 AM, Yinghai Lu wrote:
>>>
>>> If the sentinel is flagged, zero *all fields not explicitly set by the
>>> broken versions of kexec*, not just your new "ext" fields.
>>
>> other fields are pad* fields, so do we zero out them
>> with memset with exact address?
>> so next times, when someone change pad fields to other ext_*,
>> they don't need to change code again here.
>>
>
> No, there were other fields that were also left uninitialized, per your
> analysis from last year.  I don't remember the details, but I seem to
> recall they included the EFI and graphics-related fields.
>
> So yes, just zero them all out.
>

from last year's mail:

---
the one with *
? means set only when lfb_depth > 8
also
   0xa2 to 0x1df is not set

struct x86_linux_param_header {
        uint8_t  orig_x;                        /* 0x00 */  *
        uint8_t  orig_y;                        /* 0x01 */  *
        uint16_t ext_mem_k;                     /* 0x02 -- EXT_MEM_K
sits here */   *
        uint16_t orig_video_page;               /* 0x04 */  *
        uint8_t  orig_video_mode;               /* 0x06 */  *
        uint8_t  orig_video_cols;               /* 0x07 */  *
        uint16_t unused2;                       /* 0x08 */
        uint16_t orig_video_ega_bx;             /* 0x0a */  *
        uint16_t unused3;                       /* 0x0c */
        uint8_t  orig_video_lines;              /* 0x0e */  *
        uint8_t  orig_video_isVGA;              /* 0x0f */   *
        uint16_t orig_video_points;             /* 0x10 */   *

        /* VESA graphic mode -- linear frame buffer */
        uint16_t lfb_width;                     /* 0x12 */   *
        uint16_t lfb_height;                    /* 0x14 */   *
        uint16_t lfb_depth;                     /* 0x16 */   *
        uint32_t lfb_base;                      /* 0x18 */   *
        uint32_t lfb_size;                      /* 0x1c */   *
        uint16_t cl_magic;                      /* 0x20 */   *
#define CL_MAGIC_VALUE 0xA33F
        uint16_t cl_offset;                     /* 0x22 */   *
        uint16_t lfb_linelength;                /* 0x24 */   *
        uint8_t  red_size;                      /* 0x26 */   ?
        uint8_t  red_pos;                       /* 0x27 */   ?
        uint8_t  green_size;                    /* 0x28 */   ?
        uint8_t  green_pos;                     /* 0x29 */   ?
        uint8_t  blue_size;                     /* 0x2a */   ?
        uint8_t  blue_pos;                      /* 0x2b */   ?
        uint8_t  rsvd_size;                     /* 0x2c */   ?
        uint8_t  rsvd_pos;                      /* 0x2d */   ?
        uint16_t vesapm_seg;                    /* 0x2e */   *
        uint16_t vesapm_off;                    /* 0x30 */
        uint16_t pages;                         /* 0x32 */   *
        uint8_t  reserved4[12];                 /* 0x34 -- 0x3f
reserved for future expansion */

        struct apm_bios_info apm_bios_info;     /* 0x40 */   *
        struct drive_info_struct drive_info;    /* 0x80 */   *
        struct sys_desc_table sys_desc_table;   /* 0xa0 */   * only .length =
0, aka 0xa2 to 0x1df is not set
        uint32_t alt_mem_k;                     /* 0x1e0 */  *
        uint8_t  reserved5[4];                  /* 0x1e4 */
        uint8_t  e820_map_nr;                   /* 0x1e8 */  *
        uint8_t  eddbuf_entries;                /* 0x1e9 */  *
        uint8_t  edd_mbr_sig_buf_entries;       /* 0x1ea */  *
        uint8_t  reserved6[6];                  /* 0x1eb */
        HEADER.....                                         copied and
or meset 0 and set.
        uint8_t  reserved16[0x290 - 0x248];     /* 0x248 */
        uint32_t edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];   /* 0x290 */  *
#endif
        struct  e820entry e820_map[E820MAX];    /* 0x2d0 */   *
        uint8_t _pad8[48];                      /* 0xcd0 */
        struct  edd_info eddbuf[EDDMAXNR];      /* 0xd00 */   *
                                                /* 0xeec */
#define COMMAND_LINE_SIZE 2048
};

----

in kernel for 0xa2 to 0x1df:
        struct sys_desc_table sys_desc_table;           /* 0x0a0 */
        struct olpc_ofw_header olpc_ofw_header;         /* 0x0b0 */
        __u32 ext_ramdisk_image;                        /* 0x0c0 */
        __u32 ext_ramdisk_size;                         /* 0x0c4 */
        __u32 ext_cmd_line_ptr;                         /* 0x0c8 */
        __u8  _pad4[116];                               /* 0x0cc */
        struct edid_info edid_info;                     /* 0x140 */
        struct efi_info efi_info;                       /* 0x1c0 */
        __u32 alt_mem_k;                                /* 0x1e0 */

so do you mean clear from 0xa2 to 0x1df?

Thanks

Yinghai
