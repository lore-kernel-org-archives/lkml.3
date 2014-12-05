Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaLEJyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:54:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32614 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaLEJyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:54:37 -0500
Date: Fri, 5 Dec 2014 12:54:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/2] compiler: use compiler to detect integer overflows
Message-ID: <20141205095423.GB4963@mwanda>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFzyDC=o_Beg+8hjW8+TQXYWCgQo_yfjgHsTz0LRTiomWA@mail.gmail.com>
 <547620E6.10306@oracle.com>
 <CA+55aFyiCg23eL=y0nE8a-6_tBAtB097J8v_BtpUcHU8sc3hyQ@mail.gmail.com>
 <20141127204257.GA11014@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127204257.GA11014@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

Is this what you are looking for?  This list is made with next-20141204.

It's mostly code which does:

	x = foo + bar;
	if (x < foo)

We compile the kernel with -fnostrict-overflow so GCC won't optimize
these checks away.  I don't think they cause a problem?

There are some false positives which do:

	if ((u16)(u16_foo + u16_bar) < u16_foo) {

regards,
dan carpenter

kernel/events/core.c:4534 perf_sample_ustack_size() warn: signed overflow undefined. 'header_size + stack_size < header_size'
kernel/delayacct.c:112 __delayacct_add_tsk() warn: signed overflow undefined. 'd->cpu_delay_total + t2 < d->cpu_delay_total'
kernel/delayacct.c:116 __delayacct_add_tsk() warn: signed overflow undefined. 'd->cpu_run_virtual_total + t3 < d->cpu_run_virtual_total'
mm/fadvise.c:71 SYSC_fadvise64_64() warn: signed overflow undefined. 'offset + len < len'
fs/ntfs/runlist.c:778 ntfs_mapping_pairs_decompress() warn: signed overflow undefined. 'attr + () < attr'
fs/ntfs/index.c:293 ntfs_index_lookup() warn: signed overflow undefined. 'kaddr + ((vcn << idx_ni->itype.index.vcn_size_bits) & ~(~(((1) << 12) - 1))) < kaddr'
fs/ntfs/index.c:351 ntfs_index_lookup() warn: signed overflow undefined. '&ia->index + () < ia'
fs/ntfs/inode.c:507 ntfs_is_extended_system_file() warn: signed overflow undefined. 'attr + () < attr'
fs/ntfs/dir.c:336 ntfs_lookup_inode_by_name() warn: signed overflow undefined. 'kaddr + ((vcn << dir_ni->itype.index.vcn_size_bits) & ~(~(((1) << 12) - 1))) < kaddr'
fs/ntfs/dir.c:394 ntfs_lookup_inode_by_name() warn: signed overflow undefined. '&ia->index + () < ia'
fs/ntfs/dir.c:1199 ntfs_readdir() warn: signed overflow undefined. '&ir->index + () < ir'
fs/ntfs/dir.c:1313 ntfs_readdir() warn: signed overflow undefined. 'kaddr + (ia_pos & ~(~(((1) << 12) - 1)) & ~(ndir->itype.index.block_size - 1)) < kaddr'
fs/ntfs/dir.c:1381 ntfs_readdir() warn: signed overflow undefined. '&ia->index + () < ia'
fs/ntfs/super.c:1890 load_system_files() warn: signed overflow undefined. 'ctx->attr + () < ctx->attr'
fs/cifs/smb2pdu.c:1124 SMB2_open() warn: signed overflow undefined. 'uni_path_len / 8 * 8 < uni_path_len'
fs/ext4/extents.c:4794 ext4_zero_range() warn: signed overflow undefined. '(((offset) - 1) | (((1 << blkbits) - 1))) + 1 < offset'
fs/sync.c:288 SYSC_sync_file_range() warn: signed overflow undefined. 'offset + nbytes < offset'
drivers/hid/hid-tmff.c:76 tmff_scale_s8() warn: signed overflow undefined. '(((in + 128) * (maximum - minimum)) / 255) + minimum < minimum'
drivers/hid/hid-tmff.c:63 tmff_scale_u16() warn: signed overflow undefined. '(in * (maximum - minimum) / 65535) + minimum < minimum'
drivers/staging/lustre/lustre/obdclass/lprocfs_status.c:212 lprocfs_write_frac_helper() warn: signed overflow undefined. 'end + 1 < end'
drivers/staging/speakup/kobjects.c:800 message_store_helper() warn: signed overflow undefined. 'firstmessage + index < firstmessage'
drivers/scsi/mpt2sas/mpt2sas_ctl.c:1986 _ctl_diag_read_buffer() warn: signed overflow undefined. 'diag_data + karg.bytes_to_read < diag_data'
drivers/scsi/mpt3sas/mpt3sas_ctl.c:2018 _ctl_diag_read_buffer() warn: signed overflow undefined. 'diag_data + karg.bytes_to_read < diag_data'
drivers/block/floppy.c:2450 copy_buffer() warn: signed overflow undefined. 'floppy_track_buffer + ((fsector_t - buffer_min) << 9) < floppy_track_buffer'
drivers/block/floppy.c:2760 make_raw_rw_request() warn: signed overflow undefined. 'floppy_track_buffer + ((aligned_sector_t - buffer_min) << 9) < floppy_track_buffer'
drivers/infiniband/core/cma.c:2716 cma_resolve_ib_udp() warn: signed overflow undefined. 'offset + conn_param->private_data_len < conn_param->private_data_len'
drivers/infiniband/core/cma.c:2773 cma_connect_ib() warn: signed overflow undefined. 'offset + conn_param->private_data_len < conn_param->private_data_len'
drivers/video/fbdev/riva/riva_hw.c:1016 nv10CalcArbitration() warn: signed overflow undefined. '(clwm / 8) * 8 < clwm'
drivers/video/fbdev/nvidia/nv_hw.c:569 nv10CalcArbitration() warn: signed overflow undefined. '(clwm / 8) * 8 < clwm'
lib/vsprintf.c:1756 vsnprintf() warn: signed overflow undefined. 'buf + size < buf'
lib/vsprintf.c:2192 bstr_printf() warn: signed overflow undefined. 'buf + size < buf'
net/netfilter/ipset/ip_set_core.c:901 ip_set_create() warn: signed overflow undefined. 'inst->ip_set_max + 64 < inst->ip_set_max'
net/irda/irlap.c:660 irlap_generate_rand_time_slot() warn: signed overflow undefined. 's + rand % (S - s) < S'
net/sunrpc/auth_gss/gss_krb5_mech.c:193 simple_get_bytes() warn: signed overflow undefined. 'p + len < p'
net/sunrpc/auth_gss/gss_krb5_mech.c:209 simple_get_netobj() warn: signed overflow undefined. 'p + len < p'
net/sunrpc/auth_gss/gss_krb5_mech.c:296 gss_import_v1_context() warn: signed overflow undefined. 'p + 20 < p'
net/sunrpc/auth_gss/auth_gss.c:154 simple_get_bytes() warn: signed overflow undefined. 'p + len < p'
net/sunrpc/auth_gss/auth_gss.c:257 gss_fill_context() warn: signed overflow undefined. 'p + seclen < p'
net/sunrpc/auth_gss/auth_gss.c:170 simple_get_netobj() warn: signed overflow undefined. 'p + len < p'
net/sunrpc/xdr.c:572 xdr_reserve_space() warn: signed overflow undefined. 'p + (nbytes >> 2) < p'
net/sunrpc/xdr.c:832 __xdr_inline_decode() warn: signed overflow undefined. 'p + nwords < p'
security/keys/keyctl.c:856 keyctl_chown_key() warn: signed overflow undefined. 'newowner->qnbytes + key->quotalen < newowner->qnbytes'
security/keys/key.c:380 key_payload_reserve() warn: signed overflow undefined. 'key->user->qnbytes + delta < key->user->qnbytes'
