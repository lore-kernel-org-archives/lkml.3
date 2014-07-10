Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaGJAYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:24:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaGJAYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:24:12 -0400
Date: Wed, 9 Jul 2014 17:28:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Stephen Warren <swarren@nvidia.com>, Alan <gnomes@lxorguk.ukuu.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V8 2/2] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
Message-ID: <20140710002837.GA5429@kroah.com>
References: <20140530061617.21929.25777.stgit@yunodevel>
 <20140530061622.21929.82083.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530061622.21929.82083.stgit@yunodevel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 03:16:22PM +0900, Yoshihiro YUNOMAE wrote:
> Add tunable RX interrupt trigger I/F of FIFO buffers.
> 
> Serial devices are used as not only message communication devices but control
> or sending communication devices. For the latter uses, normally small data
> will be exchanged, so user applications want to receive data unit as soon as
> possible for real-time tendency. If we have a sensor which sends a 1 byte data
> each time and must control a device based on the sensor feedback, the RX
> interrupt should be triggered for each data.
> 
> According to HW specification of serial UART devices, RX interrupt trigger
> can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
> the trigger to only 8bytes.
> 
> This patch makes some devices change RX interrupt trigger from userland.
> 
> <How to use>
> - Read current setting
>  # cat /sys/class/tty/ttyS0/rx_trig_bytes
>  8
> 
> - Write user setting
>  # echo 1 > /sys/class/tty/ttyS0/rx_trig_bytes
>  # cat /sys/class/tty/ttyS0/rx_trig_bytes
>  1
> 
> <Support uart devices>
> - 16550A and Tegra (1, 4, 8, or 14 bytes)
> - 16650V2 (8, 16, 24, or 28 bytes)
> - 16654 (8, 16, 56, or 60 bytes)
> - 16750 (1, 16, 32, or 56 bytes)
> 
> Changed in V2:
>  - Use _IOW for TIOCSFIFORTRIG definition
>  - Pass the interrupt trigger value itself
> 
> Changes in V3:
>  - Change I/F from ioctl(2) to sysfs(rx_int_trig)
> 
> Changes in V4:
>  - Introduce fifo_bug flag in uart_8250_port structure
>    This is enabled only when parity is enabled and UART_BUG_PARITY is enabled
>    for up->bugs. If this flag is enabled, user cannot set RX trigger.
>  - Return -EOPNOTSUPP when it does not support device at convert_fcr2val() and
>    at convert_val2rxtrig()
>  - Set the nearest lower RX trigger when users input a meaningless value at
>    convert_val2rxtrig()
>  - Check whether p->fcr is existing at serial8250_clear_and_reinit_fifos()
>  - Set fcr = up->fcr in the begging of serial8250_do_set_termios()
> 
> Changes in V5:
>  - Support Tegra, 16650V2, 16654, and 16750
>  - Store default FCR value to up->fcr when the port is first created
>  - Add rx_trig_byte[] in uart_config[] for each device and use rx_trig_byte[]
>    in convert_fcr2val() and convert_val2rxtrig()
> 
> Changes in V5.1:
>  - Fix FCR_RX_TRIG_MAX_STATE definition
> 
> Changes in V6:
>  - Move FCR_RX_TRIG_* definition in 8250.h to include/uapi/linux/serial_reg.h,
>    rename those to UART_FCR_R_TRIG_*, and use UART_FCR_TRIGGER_MASK to
>    UART_FCR_R_TRIG_BITS()
>  - Change following function names:
>     convert_fcr2val() => fcr_get_rxtrig_bytes()
>     convert_val2rxtrig() => bytes_to_fcr_rxtrig()
>  - Fix typo in serial8250_do_set_termios()
>  - Delete the verbose error message pr_info() in bytes_to_fcr_rxtrig()
>  - Rename *rx_int_trig/rx_trig* to *rxtrig* for several functions or variables
>    (but UI remains rx_int_trig)
>  - Change the meaningless variable name 'val' to 'bytes' following functions:
>     fcr_get_rxtrig_bytes(), bytes_to_fcr_rxtrig(), do_set_rxtrig(),
>     do_serial8250_set_rxtrig(), and serial8250_set_attr_rxtrig()
>  - Use up->fcr in order to get rxtrig_bytes instead of rx_trig_raw in
>    fcr_get_rxtrig_bytes()
>  - Use conf_type->rxtrig_bytes[0] instead of switch statement for support check
>    in register_dev_spec_attr_grp()
>  - Delete the checking whether a user changed FCR or not when minimum buffer
>    is needed in serial8250_do_set_termios()
> 
> Changes in V7:
>  - Add Documentation
>  - Change I/F name from rx_int_trig to rx_trig_bytes because the name
>    rx_int_trig is hard to understand how users specify the value
> 
> Changes in V8:
>  - Divide this patch from V7's patch based on Greg's comment
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> ---
>  Documentation/ABI/testing/sysfs-tty |   16 +++
>  drivers/tty/serial/8250/8250.h      |    2 
>  drivers/tty/serial/8250/8250_core.c |  173 ++++++++++++++++++++++++++++++++---
>  include/linux/serial_8250.h         |    2 
>  include/uapi/linux/serial_reg.h     |    5 +
>  5 files changed, 183 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-tty b/Documentation/ABI/testing/sysfs-tty
> index ad22fb0..9eb3c2b 100644
> --- a/Documentation/ABI/testing/sysfs-tty
> +++ b/Documentation/ABI/testing/sysfs-tty
> @@ -138,3 +138,19 @@ Description:
>  
>  		 These sysfs values expose the TIOCGSERIAL interface via
>  		 sysfs rather than via ioctls.
> +
> +What:		/sys/class/tty/ttyS0/rx_trig_bytes
> +Date:		May 2014
> +Contact:	Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> +Description:
> +		 Shows current RX interrupt trigger bytes or sets the
> +		 user specified value to change it for the FIFO buffer.
> +		 Users can show or set this value regardless of opening the
> +		 serial device file or not.
> +
> +		 The RX trigger can be set one of four kinds of values for UART
> +		 serials. When users input a meaning less value to this I/F,
> +		 the RX trigger is changed to the nearest lower value for the
> +		 device specification. For example, when user sets 7bytes on
> +		 16550A, which has 1/4/8/14 bytes trigger, the RX trigger is
> +		 automatically changed to 4 bytes.

I really don't like the way that the tty core has been changed to handle
multiple attribute groups, as I feel tty drivers shouldn't be creating
"special" sysfs files, depending on what driver is bound to them.

Usually we have handled this using tools like 'stty' and ioctls, right?
Surely there is an ioctl to control the interrupt level, right?  Hasn't
this been covered before somehow?

thanks,

greg k-h
