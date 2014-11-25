Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaKYOHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:07:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaKYOG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:06:59 -0500
Message-ID: <54748D00.1030000@suse.de>
Date: Tue, 25 Nov 2014 15:06:56 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "J. German Rivera" <German.Rivera@freescale.com>,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
CC: stuart.yoder@freescale.com, Kim.Phillips@freescale.com,
        scottwood@freescale.com, bhamciu1@freescale.com, R89243@freescale.com,
        Geoff.Thorpe@freescale.com, bhupesh.sharma@freescale.com,
        nir.erez@freescale.com, richard.schmitt@freescale.com
Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com> <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
In-Reply-To: <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13.11.14 18:54, J. German Rivera wrote:
> APIs to access the Management Complex (MC) hardware
> module of Freescale LS2 SoCs. This patch includes
> APIs to check the MC firmware version and to manipulate
> DPRC objects in the MC.
> 
> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> ---
> Changes in v4:
> - Addressed comments from Alex Graf:
>   * Added file description for files that did not have one
>   * Removed Marshalling/unmarshalling macros invoked in MC
>     command wrapper functions, and instead do the marshalling/
>     unmarshalling directly in these functions.
>   * Added type cast u32 in status range-check in mc_status_to_error()
>   * Moved mc_write_command() and mc_read_response() inline
>     function to mc_sys.c as they are only used in that file
>   * Renamed u64_enc() as mc_enc() and u64_dec() as mc_dec()
> - Upgraded MC flibs for MC firmware 0.5
> 
> Changes in v3:
> - Addressed comment from Greg Kroah-Hartman:
>   * Removed doxygen comments
> 
> - Addressed comment from Scott Wood:
>   * Replaced udelay() call with usleep_range() call in polling loop
> - Addressed comments from Kim Phillips:
>   * Fixed license text in all files
>   * Renamed files:
> 	drivers/bus/fsl-mc/fsl_dpmng_cmd.h -> drivers/bus/fsl-mc/dpmng-cmd.h
> 	drivers/bus/fsl-mc/fsl_dprc_cmd.h -> drivers/bus/fsl-mc/dprc-cmd.h
> 	drivers/bus/fsl-mc/fsl_mc_sys.c -> drivers/bus/fsl-mc/mc-sys.c
> 	include/linux/fsl_dpmng.h -> include/linux/fsl/dpmng.h
> 	include/linux/fsl_dprc.h -> include/linux/fsl/dprc.h
> 	include/linux/fsl_mc_cmd.h -> include/linux/fsl/mc-cmd.h
> 	include/linux/fsl_mc_sys.h -> include/linux/fsl/mc-sys.h
>   * Changed dpmng_load_iop() to take the DMA address directly,
>     instead of the image virtual address.
>   * Removed if and WARN_ON that checks for NULL fsl_destroy_mc_io()
>   * Removed locking from mc_send_command(). Now the caller of MC flib
>     APIs is responsible for protecting concurrent accesses to the same
>     MC portal.
> 
> Changes in v2:
> - Addressed comment from Joe Perches:
>   * Refactored logic to actively fail on err and proceed at
>     the same indent level on success, for all functions in dprc.c
>     and dpmng.c.
> 
> - Addressed comments from Kim Phillips:
>   * Fixed warning in mc_send_command
>   * Changed serialization logic in mc_send_command() to only use
>     spinlock_irqsave() when both threads and interrupt handlers
>     concurrently access the same portal.
>   * Changed switch to lookup table in mc_status_to_error()
>   * Removed macros iowrite64(), ioread64(), ENOTSUP from fsl_mc_sys.h
>   * Removed #ifdef side for FSL_MC_FIRMWARE in fsl_mc_cmd.h
>   * Changed non-devm_ API calls to devm_ API calls and refactored
>     fsl_create_mc_io()/fsl_destroy_mc_io() to simplify cleanup logic.
> 
> - Addressed comments from Scott Wood:
>   * Return -ENXIO instead of -EFAULT when ioremap_nocache() fails
> 
> - Addressed comments from Alex Graf:
>   * Added MAINTAINERS file entries for new files
>   * Added dev param to fsl_create_mc_io(), to enable the use
>     of devm_ APIs in this function and fsl_destroy_mc_io().
>   * Changed the value of the timeout for MC command completion
>     to be a function of HZ instead of a hard-coded jiffies value.
> 
>  MAINTAINERS                    |   8 +
>  drivers/bus/fsl-mc/dpmng-cmd.h |  50 +++
>  drivers/bus/fsl-mc/dpmng.c     | 126 ++++++
>  drivers/bus/fsl-mc/dprc-cmd.h  |  85 ++++
>  drivers/bus/fsl-mc/dprc.c      | 933 +++++++++++++++++++++++++++++++++++++++++
>  drivers/bus/fsl-mc/mc-sys.c    | 284 +++++++++++++
>  include/linux/fsl/dpmng.h      | 151 +++++++
>  include/linux/fsl/dprc.h       | 868 ++++++++++++++++++++++++++++++++++++++
>  include/linux/fsl/mc-cmd.h     | 109 +++++
>  include/linux/fsl/mc-sys.h     |  70 ++++
>  10 files changed, 2684 insertions(+)
>  create mode 100644 drivers/bus/fsl-mc/dpmng-cmd.h
>  create mode 100644 drivers/bus/fsl-mc/dpmng.c
>  create mode 100644 drivers/bus/fsl-mc/dprc-cmd.h
>  create mode 100644 drivers/bus/fsl-mc/dprc.c
>  create mode 100644 drivers/bus/fsl-mc/mc-sys.c
>  create mode 100644 include/linux/fsl/dpmng.h
>  create mode 100644 include/linux/fsl/dprc.h
>  create mode 100644 include/linux/fsl/mc-cmd.h
>  create mode 100644 include/linux/fsl/mc-sys.h
> 

[...]

> +/**
> + * Sends an command to the MC device using the given MC I/O object
> + *
> + * @mc_io: MC I/O object to be used
> + * @cmd: command to be sent
> + *
> + * Returns '0' on Success; Error code otherwise.
> + *
> + * NOTE: This function cannot be invoked from from atomic contexts.
> + */
> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
> +{
> +	enum mc_cmd_status status;
> +	unsigned long irqsave_flags = 0;

drivers/bus/fsl-mc/mc-sys.c: In function ‘mc_send_command’:
drivers/bus/fsl-mc/mc-sys.c:235:16: warning: unused variable
‘irqsave_flags’ [-Wunused-variable]
  unsigned long irqsave_flags = 0;
                ^


Alex
