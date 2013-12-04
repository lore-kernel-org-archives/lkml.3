Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3LDOCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:02:36 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55199 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LDOCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:02:34 -0500
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <1386080903-27160-2-git-send-email-haver@linux.vnet.ibm.com>
References: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1386080903-27160-2-git-send-email-haver@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 04 Dec 2013 15:02:24 +0100
Message-ID: <1386165744.7883.34.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120414-8372-0000-0000-000007FA9713
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd & Greg,

please let me know if my following changes are ok:

Am Dienstag, den 03.12.2013, 15:28 +0100 schrieb Frank Haverkamp:

> +/* Read/write from/to registers */
> +struct genwqe_regs_io {
> +       __u32 num;              /* register offset/address */
> +       union {
> +               __u64 val64;
> +               __u32 val32;
> +               __u16 define;
> +       };
> +};

Here I am using now:

struct genwqe_regs_io {
	__u64 num;		/* register offset/address */
	union {
		__u64 val64;
		__u32 val32;
		__u16 define;
	};
};

> +
> +/*
> + * All registers of our card will return values not equal this
> values.
> + * If we see IO_ILLEGAL_VALUE on any of our MMIO register reads, the
> + * card can be considered as unusable. It will need recovery.
> + */
> +#define IO_ILLEGAL_VALUE               0xffffffffffffffffull
> +
> +/*
> + * Generic DDCB execution interface.
> + *
> + * This interface is a first prototype resulting from discussions we
> + * had with other teams which wanted to use the Genwqe card. It
> allows
> + * to issue a DDCB request in a generic way. The request will block
> + * until it finishes or time out with error.
> + *
> + * Some DDCBs require DMA addresses to be specified in the ASIV
> + * block. The interface provies the capability to let the kernel
> + * driver know where those addresses are by specifying the ATS field,
> + * such that it can replace the user-space addresses with appropriate
> + * DMA addresses or DMA addresses of a scatter gather list which is
> + * dynamically created.
> + *
> + * Our hardware will refuse DDCB execution if the ATS field is not as
> + * expected. That means the DDCB execution engine in the chip knows
> + * where it expects DMA addresses within the ASIV part of the DDCB
> and
> + * will check that against the ATS field definition. Any invalid or
> + * unknown ATS content will lead to DDCB refusal.
> + */
> +
> +/* Genwqe chip Units */
> +#define DDCB_ACFUNC_SLU                        0x00  /* chip service
> layer unit */
> +#define DDCB_ACFUNC_APP                        0x01  /* chip
> application */
> +
> +/* DDCB return codes (RETC) */
> +#define DDCB_RETC_IDLE                 0x0000 /* Unexecuted/DDCB
> created */
> +#define DDCB_RETC_PENDING              0x0101 /* Pending Execution */
> +#define DDCB_RETC_COMPLETE             0x0102 /* Cmd complete. No
> error */
> +#define DDCB_RETC_FAULT                        0x0104 /* App Err,
> recoverable */
> +#define DDCB_RETC_ERROR                        0x0108 /* App Err,
> non-recoverable */
> +#define DDCB_RETC_FORCED_ERROR         0x01ff /* overwritten by
> driver  */
> +
> +#define DDCB_RETC_UNEXEC               0x0110 /* Unexe/Removed from
> queue */
> +#define DDCB_RETC_TERM                 0x0120 /* Terminated */
> +#define DDCB_RETC_RES0                 0x0140 /* Reserved */
> +#define DDCB_RETC_RES1                 0x0180 /* Reserved */
> +
> +/* DDCB Command Options (CMDOPT) */
> +#define DDCB_OPT_ECHO_FORCE_NO         0x0000 /* ECHO DDCB */
> +#define DDCB_OPT_ECHO_FORCE_102                0x0001 /* force return
> code */
> +#define DDCB_OPT_ECHO_FORCE_104                0x0002
> +#define DDCB_OPT_ECHO_FORCE_108                0x0003
> +
> +#define DDCB_OPT_ECHO_FORCE_110                0x0004 /* only on PF !
> */
> +#define DDCB_OPT_ECHO_FORCE_120                0x0005
> +#define DDCB_OPT_ECHO_FORCE_140                0x0006
> +#define DDCB_OPT_ECHO_FORCE_180                0x0007
> +
> +#define DDCB_OPT_ECHO_COPY_NONE                (0 << 5)
> +#define DDCB_OPT_ECHO_COPY_ALL         (1 << 5)
> +
> +/* Definitions of Service Layer Commands */
> +#define SLCMD_ECHO_SYNC                        0x00 /* PF/VF */
> +#define SLCMD_MOVE_FLASH               0x06 /* PF only */
> +#define SLCMD_MOVE_FLASH_FLAGS_MODE    0x03 /* bit 0 and 1 used for
> mode */
> +#define SLCMD_MOVE_FLASH_FLAGS_DLOAD   0       /* mode: download  */
> +#define SLCMD_MOVE_FLASH_FLAGS_EMUL    1       /* mode: emulation */
> +#define SLCMD_MOVE_FLASH_FLAGS_UPLOAD  2       /* mode: upload    */
> +#define SLCMD_MOVE_FLASH_FLAGS_VERIFY  3       /* mode: verify    */
> +#define SLCMD_MOVE_FLASH_FLAG_NOTAP    (1 << 2)/* just dump DDCB and
> exit */
> +#define SLCMD_MOVE_FLASH_FLAG_POLL     (1 << 3)/* wait for RETC >=
> 0102   */
> +#define SLCMD_MOVE_FLASH_FLAG_PARTITION        (1 << 4)
> +#define SLCMD_MOVE_FLASH_FLAG_ERASE    (1 << 5)
> +
> +enum genwqe_card_state {
> +       GENWQE_CARD_UNUSED = 0,
> +       GENWQE_CARD_USED = 1,
> +       GENWQE_CARD_FATAL_ERROR = 2,
> +       GENWQE_CARD_STATE_MAX,
> +};
> +
> +/* common struct for chip image exchange */
> +struct genwqe_bitstream {
> +       __u64 data_addr;                /* pointer to image data */
> +       __u32 size;                     /* size of image file */
> +       __u32 crc;                      /* crc of this image */
> +       __u8  partition;                /* '0', '1', or 'v' */
> +       __u64 target_addr;              /* starting address in Flash
> */
> +       __u8  uid;                      /* 1=host/x=dram */
> +
> +       __u64 slu_id;                   /* informational/sim: SluID */
> +       __u64 app_id;                   /* informational/sim: AppID */
> +
> +       __u16 retc;                     /* returned from processing */
> +       __u16 attn;                     /* attention code from
> processing */
> +       __u32 progress;                 /* progress code from
> processing */
> +};

Here I reordered and resized the members like this:

struct genwqe_bitstream {
	__u64 data_addr;		/* pointer to image data */
	__u32 size;			/* size of image file */
	__u32 crc;			/* crc of this image */
	__u64 target_addr;		/* starting address in Flash */
	__u32 partition;		/* '0', '1', or 'v' */
	__u32 uid;			/* 1=host/x=dram */

	__u64 slu_id;			/* informational/sim: SluID */
	__u64 app_id;			/* informational/sim: AppID */

	__u16 retc;			/* returned from processing */
	__u16 attn;			/* attention code from processing */
	__u32 progress;			/* progress code from processing */
};

> +
> +/* Issuing a specific DDCB command */
> +#define DDCB_LENGTH                    256 /* for debug data */
> +#define DDCB_ASIV_LENGTH               104 /* len of the DDCB ASIV
> array */
> +#define DDCB_ASIV_LENGTH_ATS           96  /* ASIV in ATS
> architecture */
> +#define DDCB_ASV_LENGTH                        64  /* len of the DDCB
> ASV array  */
> +#define DDCB_FIXUPS                    12  /* maximum number of
> fixups */
> +
> +struct genwqe_debug_data {
> +       char driver_version[64];
> +       __u64 slu_unitcfg;
> +       __u64 app_unitcfg;
> +
> +       __u8  ddcb_before[DDCB_LENGTH];
> +       __u8  ddcb_prev[DDCB_LENGTH];
> +       __u8  ddcb_finished[DDCB_LENGTH];
> +};
> +

This I hope is ok. DDCB_LENGTH is 256.

> +/*
> + * Address Translation Specification (ATS) definitions
> + *
> + * Each 4 bit within the ATS 64-bit word specify the required address
> + * translation at the defined offset.
> + *
> + * 63 LSB
> + *         6666.5555.5555.5544.4444.4443.3333.3333 ... 11
> + *         3210.9876.5432.1098.7654.3210.9876.5432 ... 1098.7654.3210
> + *
> + * offset: 0x00 0x08 0x10 0x18 0x20 0x28 0x30 0x38 ... 0x68 0x70 0x78
> + *         res  res  res  res  ASIV ...
> + * The first 4 entries in the ATS word are reserved. The following
> nibbles
> + * each describe at an 8 byte offset the format of the required data.
> + */
> +#define ATS_TYPE_DATA                  0x0ull /* data  */
> +#define ATS_TYPE_FLAT_RD               0x4ull /* flat buffer read
> only */
> +#define ATS_TYPE_FLAT_RDWR             0x5ull /* flat buffer
> read/write */
> +#define ATS_TYPE_SGL_RD                        0x6ull /* sgl read
> only */
> +#define ATS_TYPE_SGL_RDWR              0x7ull /* sgl read/write */
> +
> +#define ATS_SET_FLAGS(_struct, _field,
> _flags)                         \
> +       (((_flags) & 0xf) << (44 - (4 * (offsetof(_struct, _field) /
> 8))))
> +
> +#define ATS_GET_FLAGS(_ats,
> _byte_offs)                                        \
> +       (((_ats)          >> (44 - (4 * ((_byte_offs) / 8)))) & 0xf)
> +
> +/**
> + * struct genwqe_ddcb_cmd - User parameter for generic DDCB commands
> + *
> + * On the way into the kernel the driver will read the whole data
> + * structure. On the way out the driver will not copy the ASIV data
> + * back to user-space.
> + */
> +struct genwqe_ddcb_cmd {
> +       /* ------ START of data copied to/from driver
> ---------------------- */
> +       __u64 next_addr;                /* chaining genwqe_ddcb_cmd */
> +
> +       /* XDIR might be needed one day to allow to ignore errors. But
> +          that is an interface change and should be treated with some
> +          caution. */
> +       __u8  acfunc;                   /* accelerators functional
> unit */
> +       __u8  cmd;                      /* command to execute */
> +       __u16 cmdopts;                  /* command options */
> +
> +       __u8  asiv_length;              /* used parameter length */
> +       __u8  asv_length;               /* length of valid return
> values  */
> +
> +       __u16 retc;                     /* return code from processing
> */
> +       __u16 attn;                     /* attention code from
> processing */
> +       __u32 progress;                 /* progress code from
> processing  */
> +
> +       __u16 vcrc;                     /* variant crc16 */
> +       __u64 deque_ts;                 /* dequeue time stamp */
> +       __u64 cmplt_ts;                 /* completion time stamp */
> +       __u64 disp_ts;                  /* SW processing start */
> +
> +       /* move to end and avoid copy-back */
> +       __u64 ddata_addr;               /* collect debug data */
> +
> +       /* command specific values */
> +       __u8  asv[DDCB_ASV_LENGTH];
> +
> +       /* ------ END of data copied from driver
> --------------------------- */
> +       union {
> +               struct {
> +                       __u64 ats;
> +                       __u8  asiv[DDCB_ASIV_LENGTH_ATS];
> +               };
> +               /* used for flash update to keep it backward
> compatible */
> +               __u8 __asiv[DDCB_ASIV_LENGTH];
> +       };
> +       /* ------ END of data copied to driver
> ----------------------------- */
> +};

Was this already ok? My new version looks as follows:

struct genwqe_ddcb_cmd {
	/* START of data copied to/from driver */
	__u64 next_addr;		/* chaining genwqe_ddcb_cmd */
	__u64 flags;			/* reserved */

	__u8  acfunc;			/* accelerators functional unit */
	__u8  cmd;			/* command to execute */
	__u8  asiv_length;		/* used parameter length */
	__u8  asv_length;		/* length of valid return values  */
	__u16 cmdopts;			/* command options */
	__u16 retc;			/* return code from processing    */

	__u16 attn;			/* attention code from processing */
	__u16 vcrc;			/* variant crc16 */
	__u32 progress;			/* progress code from processing  */

	__u64 deque_ts;			/* dequeue time stamp */
	__u64 cmplt_ts;			/* completion time stamp */
	__u64 disp_ts;			/* SW processing start */

	/* move to end and avoid copy-back */
	__u64 ddata_addr;		/* collect debug data */

	/* command specific values */
	__u8  asv[DDCB_ASV_LENGTH];

	/* END of data copied from driver */
	union {
		struct {
			__u64 ats;
			__u8  asiv[DDCB_ASIV_LENGTH_ATS];
		};
		/* used for flash update to keep it backward compatible */
		__u8 __asiv[DDCB_ASIV_LENGTH];
	};
	/* END of data copied to driver */
};

Trying to group the data in 64bit chunks even nicer than I had it
before.

> +
> +#define GENWQE_IOC_CODE            0xa5
> +
> +/* Access functions */
> +#define GENWQE_READ_REG64   _IOR(GENWQE_IOC_CODE, 30, struct
> genwqe_regs_io *)
> +#define GENWQE_WRITE_REG64  _IOW(GENWQE_IOC_CODE, 31, struct
> genwqe_regs_io *)
> +#define GENWQE_READ_REG32   _IOR(GENWQE_IOC_CODE, 32, struct
> genwqe_regs_io *)
> +#define GENWQE_WRITE_REG32  _IOW(GENWQE_IOC_CODE, 33, struct
> genwqe_regs_io *)
> +#define GENWQE_READ_REG16   _IOR(GENWQE_IOC_CODE, 34, struct
> genwqe_regs_io *)
> +#define GENWQE_WRITE_REG16  _IOW(GENWQE_IOC_CODE, 35, struct
> genwqe_regs_io *)
> +
> +#define GENWQE_GET_CARD_STATE _IOR(GENWQE_IOC_CODE,
> 36,                \
> +                                  enum genwqe_card_state *)
> +
> +/**
> + * struct genwqe_mem - Memory pinning/unpinning information
> + * @addr:          virtual user space address
> + * @size:          size of the area pin/dma-map/unmap
> + * direction:      0: read/1: read and write
> + *
> + * Avoid pinning and unpinning of memory pages dynamically. Instead
> + * the idea is to pin the whole buffer space required for DDCB
> + * opertionas in advance. The driver will reuse this pinning and the
> + * memory associated with it to setup the sglists for the DDCB
> + * requests without the need to allocate and free memory or map and
> + * unmap to get the DMA addresses.
> + *
> + * The inverse operation needs to be called after the pinning is not
> + * needed anymore. The pinnings else the pinnings will get removed
> + * after the device is closed. Note that pinnings will required
> + * memory.
> + */
> +struct genwqe_mem {
> +       unsigned long addr;
> +       unsigned long size;
> +       int direction;
> +};

Was wrong, as already pointed out before. It is now:

struct genwqe_mem {
	__u64 addr;
	__u64 size;
	int direction;
};

I hope the int is ok here.

> +
> +#define GENWQE_PIN_MEM       _IOWR(GENWQE_IOC_CODE, 40, struct
> genwqe_mem *)
> +#define GENWQE_UNPIN_MEM      _IOWR(GENWQE_IOC_CODE, 41, struct
> genwqe_mem *)
> +
> +/*
> + * Generic synchronous DDCB execution interface.
> + * Synchronously execute a DDCB.
> + *
> + * Return: 0 on success or negative error code.
> + *         -EINVAL: Invalid parameters (ASIV_LEN, ASV_LEN, illegal
> fixups
> + *                  no mappings found/could not create mappings
> + *         -EFAULT: illegal addresses in fixups, purging failed
> + *         -EBADMSG: enqueing failed, retc != DDCB_RETC_COMPLETE
> + */
> +#define GENWQE_EXECUTE_DDCB                                    \
> +       _IOWR(GENWQE_IOC_CODE, 50, struct genwqe_ddcb_cmd *)
> +
> +#define
> GENWQE_EXECUTE_RAW_DDCB                                        \
> +       _IOWR(GENWQE_IOC_CODE, 51, struct genwqe_ddcb_cmd *)
> +
> +/* Service Layer functions (PF only) */
> +#define GENWQE_SLU_UPDATE  _IOWR(GENWQE_IOC_CODE, 80, struct
> genwqe_bistream *)
> +#define GENWQE_SLU_READ           _IOWR(GENWQE_IOC_CODE, 81, struct
> genwqe_bistream *)
> +
> +#endif /* __GENWQE_CARD_H__ */ 

Regards

Frank

