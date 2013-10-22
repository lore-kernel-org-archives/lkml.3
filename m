Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3JVNaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:30:55 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1136 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3JVNay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:30:54 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Yuval Mintz" <yuvalmin@broadcom.com>
To: "Nate Klein" <nxk@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
cc: "Eilon Greenstein" <eilong@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net-bnx2x: Fix byte order problem on NVRAM writes
Thread-Topic: [PATCH] net-bnx2x: Fix byte order problem on NVRAM writes
Thread-Index: AQHOzqiZv1XMe1qrq0OCy3jbQdNoM5oAtXrA
Date: Tue, 22 Oct 2013 13:30:41 +0000
Message-ID: <979A8436335E3744ADCD3A9F2A2B68A52AEABE99@SJEXCHMB10.corp.ad.broadcom.com>
References: <1382392621-8998-1-git-send-email-nxk@google.com>
In-Reply-To: <1382392621-8998-1-git-send-email-nxk@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E78A2704RS189107-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tested:
>     ethtool -e eth0 raw on >first.nvram
>     ethtool -E eth0 <first.nvram
>     ethtool -e eth0 raw on >second.nvram
>     cmp first.nvram second.nvram || ethtool -E eth0 <second.nvram
>     (No output means pass.)

Hi Nate,

We're aware of this `bug' for some time - we've encountered it when
trying to fix the endian sparse warnings in the driver.

Sadly, there are already existing user applications that assume that this is 
the driver's behaviour - i.e., those applications prepare their buffers in a 
manner which assumes the endian of the writes; changing this write will 
cause those tools to break.
That's why we haven't fixed the issue before, and cannot support such a
fix. We're more than willing to document it somewhere, if that seems 
useful to anyone.

Thanks,
Yuval

> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> index 8213cc8..35671fb 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c
> @@ -1549,7 +1549,7 @@ static int bnx2x_nvram_write_dword(struct bnx2x
> *bp, u32 offset, u32 val,
>  	REG_WR(bp, MCP_REG_MCPR_NVM_COMMAND,
> MCPR_NVM_COMMAND_DONE);
> 
>  	/* write the data */
> -	REG_WR(bp, MCP_REG_MCPR_NVM_WRITE, val);
> +	REG_WR(bp, MCP_REG_MCPR_NVM_WRITE, cpu_to_be32(val));
> 
>  	/* address of the NVRAM to write to */
>  	REG_WR(bp, MCP_REG_MCPR_NVM_ADDR,
> --


