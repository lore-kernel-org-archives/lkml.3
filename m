Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3LECjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:39:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3LECjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:39:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: haver@linux.vnet.ibm.com
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
Date: Thu, 5 Dec 2013 03:38:54 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com> <1386080903-27160-2-git-send-email-haver@linux.vnet.ibm.com> <1386165744.7883.34.camel@oc7383187364.ibm.com>
In-Reply-To: <1386165744.7883.34.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312050338.54841.arnd@arndb.de>
X-Provags-ID: V02:K0:PE+9+9wa/slCY8x1DKFYwHo6FH9muk6Vr7/GRkY380k
 RRELB387XK4L2EcwK9V2w35ilizRBnhYfbx/VPDtzQwpz+o7SB
 k4LUEDvduhsMmdYg3O6u1FYFG19nhop3xQkZEylcG8z9H5Gf8z
 z0aBrtbST8JIvSTjrwv1wv3wW4YBPPpVJfIKiKjg0EBcbl1si+
 /4qoiWOGE1PI4V+7uwSCJ0QIqWtGXlo3HP8+aPleHj3dpjiqXX
 zSUdJvJcFrwsvv9x2km937Ia3CMcsbefMgAnN48B6cT3BbedRn
 ytmQqk3+9y8+/z3TBIi8zyJaU2SLZCtu91qUtQ5mOxHHAjusII
 zQ/oz3Dbj/hnJ3tNhZUA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013, Frank Haverkamp wrote:
> Hi Arnd & Greg,
> 
> please let me know if my following changes are ok:
> 
> Am Dienstag, den 03.12.2013, 15:28 +0100 schrieb Frank Haverkamp:
> 
> > +/* Read/write from/to registers */
> > +struct genwqe_regs_io {
> > +       __u32 num;              /* register offset/address */
> > +       union {
> > +               __u64 val64;
> > +               __u32 val32;
> > +               __u16 define;
> > +       };
> > +};
> 
> Here I am using now:
> 
> struct genwqe_regs_io {
> 	__u64 num;		/* register offset/address */
> 	union {
> 		__u64 val64;
> 		__u32 val32;
> 		__u16 define;
> 	};
> };

This is not a bug anymore, but it seems pointless to use a union
there rather than just a __u64 for the value.

> Here I reordered and resized the members like this:
> 
> struct genwqe_bitstream {
> 	__u64 data_addr;		/* pointer to image data */
> 	__u32 size;			/* size of image file */
> 	__u32 crc;			/* crc of this image */
> 	__u64 target_addr;		/* starting address in Flash */
> 	__u32 partition;		/* '0', '1', or 'v' */
> 	__u32 uid;			/* 1=host/x=dram */
> 
> 	__u64 slu_id;			/* informational/sim: SluID */
> 	__u64 app_id;			/* informational/sim: AppID */
> 
> 	__u16 retc;			/* returned from processing */
> 	__u16 attn;			/* attention code from processing */
> 	__u32 progress;			/* progress code from processing */
> };

Yes, this is fine.

> > +struct genwqe_debug_data {
> > +       char driver_version[64];
> > +       __u64 slu_unitcfg;
> > +       __u64 app_unitcfg;
> > +
> > +       __u8  ddcb_before[DDCB_LENGTH];
> > +       __u8  ddcb_prev[DDCB_LENGTH];
> > +       __u8  ddcb_finished[DDCB_LENGTH];
> > +};
> > +
> 
> This I hope is ok. DDCB_LENGTH is 256.

Yes.

> 
> Was this already ok? My new version looks as follows:

The old version was wrong.

> struct genwqe_ddcb_cmd {
> 	/* START of data copied to/from driver */
> 	__u64 next_addr;		/* chaining genwqe_ddcb_cmd */
> 	__u64 flags;			/* reserved */
> 
> 	__u8  acfunc;			/* accelerators functional unit */
> 	__u8  cmd;			/* command to execute */
> 	__u8  asiv_length;		/* used parameter length */
> 	__u8  asv_length;		/* length of valid return values  */
> 	__u16 cmdopts;			/* command options */
> 	__u16 retc;			/* return code from processing    */


> 	__u16 attn;			/* attention code from processing */
> 	__u16 vcrc;			/* variant crc16 */
> 	__u32 progress;			/* progress code from processing  */
> 
> 	__u64 deque_ts;			/* dequeue time stamp */
> 	__u64 cmplt_ts;			/* completion time stamp */
> 	__u64 disp_ts;			/* SW processing start */
> 
> 	/* move to end and avoid copy-back */
> 	__u64 ddata_addr;		/* collect debug data */
> 
> 	/* command specific values */
> 	__u8  asv[DDCB_ASV_LENGTH];
> 
> 	/* END of data copied from driver */
> 	union {
> 		struct {
> 			__u64 ats;
> 			__u8  asiv[DDCB_ASIV_LENGTH_ATS];
> 		};
> 		/* used for flash update to keep it backward compatible */
> 		__u8 __asiv[DDCB_ASIV_LENGTH];
> 	};
> 	/* END of data copied to driver */
> };
> 
> Trying to group the data in 64bit chunks even nicer than I had it
> before.

Yes, this works, although I would argue that it is too complex to be a nice
interface.

> > +/**
> > + * struct genwqe_mem - Memory pinning/unpinning information
> > + * @addr:          virtual user space address
> > + * @size:          size of the area pin/dma-map/unmap
> > + * direction:      0: read/1: read and write
> > + *
> > + * Avoid pinning and unpinning of memory pages dynamically. Instead
> > + * the idea is to pin the whole buffer space required for DDCB
> > + * opertionas in advance. The driver will reuse this pinning and the
> > + * memory associated with it to setup the sglists for the DDCB
> > + * requests without the need to allocate and free memory or map and
> > + * unmap to get the DMA addresses.
> > + *
> > + * The inverse operation needs to be called after the pinning is not
> > + * needed anymore. The pinnings else the pinnings will get removed
> > + * after the device is closed. Note that pinnings will required
> > + * memory.
> > + */
> > +struct genwqe_mem {
> > +       unsigned long addr;
> > +       unsigned long size;
> > +       int direction;
> > +};
> 
> Was wrong, as already pointed out before. It is now:
> 
> struct genwqe_mem {
> 	__u64 addr;
> 	__u64 size;
> 	int direction;
> };
> 
> I hope the int is ok here.

No, it's not. The problem is that sizeof(struct genwqe_mem) is now 24 on
most architectures (including x86-64) and 20 on x86-32. The size gets
encoded into the ioctl number, at least after you fix this part:

> > +
> > +#define GENWQE_PIN_MEM       _IOWR(GENWQE_IOC_CODE, 40, struct
> > genwqe_mem *)
> > +#define GENWQE_UNPIN_MEM      _IOWR(GENWQE_IOC_CODE, 41, struct
> > genwqe_mem *)

... which is also broken because sizeof(struct genwqe_mem *) is 8 on
64-bit and 4 on 32-bit architectures. The argument to _IOWR() is
supposed to be struct, not a pointer. I thought we would actually
cause a build-time warning about this bug (I wrote the code to do that)
but I may be misremembering which bugs we can actually catch.

> > +/*
> > + * Generic synchronous DDCB execution interface.
> > + * Synchronously execute a DDCB.
> > + *
> > + * Return: 0 on success or negative error code.
> > + *         -EINVAL: Invalid parameters (ASIV_LEN, ASV_LEN, illegal
> > fixups
> > + *                  no mappings found/could not create mappings
> > + *         -EFAULT: illegal addresses in fixups, purging failed
> > + *         -EBADMSG: enqueing failed, retc != DDCB_RETC_COMPLETE
> > + */
> > +#define GENWQE_EXECUTE_DDCB                                    \
> > +       _IOWR(GENWQE_IOC_CODE, 50, struct genwqe_ddcb_cmd *)
> > +
> > +#define
> > GENWQE_EXECUTE_RAW_DDCB                                        \
> > +       _IOWR(GENWQE_IOC_CODE, 51, struct genwqe_ddcb_cmd *)
> > +
> > +/* Service Layer functions (PF only) */
> > +#define GENWQE_SLU_UPDATE  _IOWR(GENWQE_IOC_CODE, 80, struct
> > genwqe_bistream *)
> > +#define GENWQE_SLU_READ           _IOWR(GENWQE_IOC_CODE, 81, struct
> > genwqe_bistream *)

Same bug for all of these.

	Arnd
