Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab3CETML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:12:11 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:49379 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3CETMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:12:09 -0500
MIME-Version: 1.0
In-Reply-To: <9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com>
References: <20130228205206.GC3438@sgi.com>
	<512FC697.3090608@zytor.com>
	<20130228210910.GD3438@sgi.com>
	<512FC82B.40909@zytor.com>
	<CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com>
	<512FE3AE.4070903@zytor.com>
	<20130305081519.GA19165@sgi.com>
	<9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com>
Date: Tue, 5 Mar 2013 11:12:08 -0800
X-Google-Sender-Auth: D9T6Q_6hnsSHG_6iyV9V-vqLcYU
Message-ID: <CAE9FiQV2Wk+yiqR8FnNM_L-p1iQFxDwopRzFWTwm6VCkyrbuoQ@mail.gmail.com>
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, hpa@sgi.com, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae93406dff4dd1304d7323f7c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae93406dff4dd1304d7323f7c
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Mar 5, 2013 at 7:22 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yes, please do the analysis I asked for.

it uses first 2 pages in bzImage to bootparams.

then update the fields with ===> X

struct boot_params {
        struct screen_info screen_info;                 /* 0x000 */   ===> X
        struct apm_bios_info apm_bios_info;             /* 0x040 */   ===> X
        __u8  _pad2[4];                                 /* 0x054 */
        __u64  tboot_addr;                              /* 0x058 */
        struct ist_info ist_info;                       /* 0x060 */
        __u8  _pad3[16];                                /* 0x070 */
        __u8  hd0_info[16];     /* obsolete! */         /* 0x080 */   ===> X
        __u8  hd1_info[16];     /* obsolete! */         /* 0x090 */   ===> X
        struct sys_desc_table sys_desc_table;           /* 0x0a0 */   ===> X
        struct olpc_ofw_header olpc_ofw_header;         /* 0x0b0 */
        __u32 ext_ramdisk_image;                        /* 0x0c0 */
        __u32 ext_ramdisk_size;                         /* 0x0c4 */
        __u32 ext_cmd_line_ptr;                         /* 0x0c8 */
        __u8  _pad4[116];                               /* 0x0cc */
        struct edid_info edid_info;                     /* 0x140 */
        struct efi_info efi_info;                       /* 0x1c0 */   ===> X
        __u32 alt_mem_k;                                /* 0x1e0 */   ===> X
        __u32 scratch;          /* Scratch field! */    /* 0x1e4 */
        __u8  e820_entries;                             /* 0x1e8 */  ===> X
        __u8  eddbuf_entries;                           /* 0x1e9 */
        __u8  edd_mbr_sig_buf_entries;                  /* 0x1ea */
        __u8  kbd_status;                               /* 0x1eb */
        __u8  _pad5[3];                                 /* 0x1ec */
        /*
         * The sentinel is set to a nonzero value (0xff) in header.S.
         *
         * A bootloader is supposed to only take setup_header and put
         * it into a clean boot_params buffer. If it turns out that
         * it is clumsy or too generous with the buffer, it most
         * probably will pick up the sentinel variable too. The fact
         * that this variable then is still 0xff will let kernel
         * know that some variables in boot_params are invalid and
         * kernel should zero out certain portions of boot_params.
         */
        __u8  sentinel;                                 /* 0x1ef */
        __u8  _pad6[1];                                 /* 0x1f0 */
        struct setup_header hdr;    /* setup header */  /* 0x1f1 */  ===> X
        __u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
        __u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];      /* 0x290 */
        struct e820entry e820_map[E820MAX];             /* 0x2d0 */  ===> X
        __u8  _pad8[48];                                /* 0xcd0 */
        struct edd_info eddbuf[EDDMAXNR];               /* 0xd00 */
        __u8  _pad9[276];                               /* 0xeec */

so sentinel will be kept as 0xff, so efi_info get cleared by kernel...

Attached patches should avoid the clearing of efi_info when elilo is used.

Do we need to clear edd and pad2 and pad3 for elilo?

Thanks

Yinghai

--14dae93406dff4dd1304d7323f7c
Content-Type: application/octet-stream; name="fix_elilo.patch"
Content-Disposition: attachment; filename="fix_elilo.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdxflrdf0

LS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9ib290cGFyYW1fdXRpbHMuaCB8ICAgIDUgKysrKy0K
IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCkluZGV4OiBs
aW51eC0yLjYvYXJjaC94ODYvaW5jbHVkZS9hc20vYm9vdHBhcmFtX3V0aWxzLmgKPT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYvaW5jbHVkZS9hc20vYm9vdHBhcmFtX3V0aWxz
LmgKKysrIGxpbnV4LTIuNi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9ib290cGFyYW1fdXRpbHMuaApA
QCAtMjAsOCArMjAsMTEgQEAgc3RhdGljIHZvaWQgc2FuaXRpemVfYm9vdF9wYXJhbXMoc3RydWN0
CiAJaWYgKGJvb3RfcGFyYW1zLT5zZW50aW5lbCkgewogCQkvKmZpZWxkcyBpbiBib290X3BhcmFt
cyBhcmUgbm90IHZhbGlkLCBjbGVhciB0aGVtICovCiAJCW1lbXNldCgmYm9vdF9wYXJhbXMtPm9s
cGNfb2Z3X2hlYWRlciwgMCwKLQkJICAgICAgIChjaGFyICopJmJvb3RfcGFyYW1zLT5hbHRfbWVt
X2sgLQorCQkgICAgICAgKGNoYXIgKikmYm9vdF9wYXJhbXMtPmVmaV9pbmZvIC0KIAkJCShjaGFy
ICopJmJvb3RfcGFyYW1zLT5vbHBjX29md19oZWFkZXIpOworCQlpZiAoYm9vdF9wYXJhbXMtPmhk
ci50eXBlX29mX2xvYWRlciAhPSAweDUwKSAvKiBub3QgZWZsaW8gKi8KKwkJCW1lbXNldCgmYm9v
dF9wYXJhbXMtPmVmaV9pbmZvLCAwLAorCQkJCQkgc2l6ZW9mKGJvb3RfcGFyYW1zLT5lZmlfaW5m
bykpOwogCQltZW1zZXQoJmJvb3RfcGFyYW1zLT5rYmRfc3RhdHVzLCAwLAogCQkgICAgICAgKGNo
YXIgKikmYm9vdF9wYXJhbXMtPmhkciAtCiAJCSAgICAgICAoY2hhciAqKSZib290X3BhcmFtcy0+
a2JkX3N0YXR1cyk7Cg==
--14dae93406dff4dd1304d7323f7c--
