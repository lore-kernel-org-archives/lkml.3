Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaGQKRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:17:08 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53705 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaGQKRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:17:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Alexander Kolesnikov <akolesni@codeaurora.org>,
        Konstantin Dorfman <kdorfman@codeaurora.org>
Subject: Re: char interface to sdio, chdio.c
Date: Thu, 17 Jul 2014 12:17 +0200
Message-ID: <7228146.FsqiNq1Vpj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140717053347.GB22970@kroah.com>
References: <20140716032655.GB30412@kroah.com> <53C705DB.3040700@codeaurora.org> <20140717053347.GB22970@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SMja1boN0vtxCERXNDE4bSPMvAjwag0XioaHuXwyqt4
 NEGsUNuQKs2/PfMc9B60WAQDZjttkJHnqOFVd4wMyhAofjI825
 v16JhWWIt4JBz150JewPkzCVf+zU71G0r0/qtACQON2Gq4fjCy
 yNmXT7MI+k9KKxlcj77XF/ZK59ym2b6bH1UYnod8wiiOm8pDM8
 1aJUWaMeNoq/uVAKeKxEE2ivvJarkIpI9Xcrd194dOIYIhztf7
 5THslth1vJLak40aUCJVrVtIAEfSb78Izz0iHoAatTUrKrH05E
 gmpu0WIKP2JlJRDsQQHCk2PliQVrngV2VccAWpUdU5DTqzYKOh
 VEFVq+lndQl0z6Gq/ujQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 22:33:47 Greg KH wrote:
> + mmc: Char SDIO Device Driver

A few comments on the ioctl interface, since I suppose we'll have
to live with that once it gets merged.

> +Interface
> +=========
> +The Char SDIO Device Driver has two char device interfaces:
> + - Control Interface;
> + - Function Interface.
> +
> +Char SDIO Device Driver Control Interface consists of:
> + - open()   - device node is /dev/csdio0;
> + - close()
> + - ioctl()  - the following options are available:
> +   - CSDIO_IOC_ENABLE_HIGHSPEED_MODE;
> +   - CSDIO_IOC_SET_DATA_TRANSFER_CLOCKS;
> +   - CSDIO_IOC_ENABLE_ISR;
> +   - CSDIO_IOC_DISABLE_ISR.


The documentation doesn't match the code.:

CSDIO_IOC_GET/SET_VDD are implemented in the control device,
not the function device, and that is probably a good idea.
CSDIO_IOC_ENABLE_HIGHSPEED_MODE is not implemented
at all. CSDIO_IOC_ENABLE_ISR seems redundant with what
the CSDIO_IOC_{DIS,}CONNECT_ISR functions do, but I could be
wrong here.

The sysfs interface may actually be more appropriate than the
control node, if I was to pick one of the two.

> +Char SDIO Device Driver Function Interface consists of:
> + - open()  - device node is /dev/csdiofX, where X is Function Id;
> + - close()
> + - read()  - send CMD53 read;
> + - write() - send CMD53 write;
> + - ioctl() - the following options are available:
> +   - CSDIO_IOC_SET_OP_CODE - 0 fixed adrress, 1 autoincrement.
> +   - CSDIO_IOC_FUNCTION_SET_BLOCK_SIZE;
> +   - CSDIO_IOC_SET_BLOCK_MODE - 0 byte mode, 1 block mode;
> +   - CSDIO_IOC_CMD52 - execute CMD52, receives the
> +        following structure as a parameter:
> +            struct csdio_cmd52_ctrl_t {
> +	            uint32_t    m_write; // 0 - read, 1 -write
> +	            uint32_t    m_address;
> +	            uint32_t    m_data;  // data to write or read data
> +	            uint32_t    m_ret;   // command execution status
> +            }__attribute__ ((packed));
> +   - CSDIO_IOC_CMD53 - setup CMD53 data transfer, receives the
> +        following structure as a parameter:
> +            struct csdio_cmd53_ctrl_t {
> +	            uint32_t    m_block_mode;
> +	            uint32_t    m_op_code;
> +	            uint32_t    m_address;
> +            }__attribute__ ((packed));
> +   - CSDIO_IOC_CONNECT_ISR;
> +   - CSDIO_IOC_DISCONNECT_ISR;
> +   - CSDIO_IOC_GET_VDD;
> +   - CSDIO_IOC_SET_VDD.
> +
> +Additionally, user space application can use fcntl system call with
> +parameters F_SETOWN and F_SETFL in order to set an asynchronous
> +callback for SDIO interrupt.

The read/write API seems very strange. SDIO has multiple ways of
passing data between OS and device using CMD52 and CMD53, and they
are all done differently here:

- A one-byte read or write uses a single CSDIO_IOC_CMD52 ioctl.
  This could be done using pread/pwrite with length '1' rather than
  an ioctl, if we want to.

- a byte-addressed multi-byte read/write needs to first 'seek' using
  CSDIO_IOC_CMD53 or and then transfer using read() or write().

- a block-addressed read/write is similar, but the number of bytes
  copied to/from user space is now multiplied with the block size (!).
  The block size needs to be set using both CSDIO_IOC_SET_BLOCK_MODE
  and CSDIO_IOC_CMD53, using the same value.

- to do a multi-byte read/write at a constant address rather than
  a block copy, CSDIO_IOC_CMD53 needs to set at least one bit (not
  necessarily the one used in the actual command) in m_op_code.

I guess all of this could be done using pread/pwrite, using the
loff_t value to encode the m_address in the lower bits and the
mode (single-byte, multi-byte, multi-byte auto-increment,
block, block auto-increment) in some of the upper bits.

Alternatively, the read/write functions could be removed completely
and everything be done in the ioctls, but in a more consistent
way.

> +
> +#define CSDIO_IOC_MAGIC  'm'
> +
> +#define CSDIO_IOC_ENABLE_HIGHSPEED_MODE      _IO(CSDIO_IOC_MAGIC, 0)
> +#define CSDIO_IOC_SET_DATA_TRANSFER_CLOCKS   _IO(CSDIO_IOC_MAGIC, 1)
> +#define CSDIO_IOC_SET_OP_CODE                _IO(CSDIO_IOC_MAGIC, 2)
> +#define CSDIO_IOC_FUNCTION_SET_BLOCK_SIZE    _IO(CSDIO_IOC_MAGIC, 3)
> +#define CSDIO_IOC_SET_BLOCK_MODE             _IO(CSDIO_IOC_MAGIC, 4)
> +#define CSDIO_IOC_CONNECT_ISR                _IO(CSDIO_IOC_MAGIC, 5)
> +#define CSDIO_IOC_DISCONNECT_ISR             _IO(CSDIO_IOC_MAGIC, 6)
> +#define CSDIO_IOC_CMD52                      _IO(CSDIO_IOC_MAGIC, 7)
> +#define CSDIO_IOC_CMD53                      _IO(CSDIO_IOC_MAGIC, 8)
> +#define CSDIO_IOC_ENABLE_ISR                 _IO(CSDIO_IOC_MAGIC, 9)
> +#define CSDIO_IOC_DISABLE_ISR                _IO(CSDIO_IOC_MAGIC, 10)
> +#define CSDIO_IOC_SET_VDD                    _IO(CSDIO_IOC_MAGIC, 11)
> +#define CSDIO_IOC_GET_VDD                    _IO(CSDIO_IOC_MAGIC, 12)
> +
> +#define CSDIO_IOC_MAXNR   12

The command codes above should use _IOR or _IOW where appropriate to
encode the size of the transferred data.

> +
> +struct csdio_cmd53_ctrl_t {
> +	uint32_t    m_block_mode;   /* data tran. byte(0)/block(1) mode */
> +	uint32_t    m_op_code;      /* address auto increment flag */
> +	uint32_t    m_address;
> +} __attribute__ ((packed));
> +
> +struct csdio_cmd52_ctrl_t {
> +	uint32_t    m_write;
> +	uint32_t    m_address;
> +	uint32_t    m_data;
> +	uint32_t    m_ret;
> +} __attribute__ ((packed));

The packing is not necessary here, but at least all of these are
compatible between 32 and 64 bit, so enabling compat mode is a one-line
change and requires no conversion.

	Arnd
