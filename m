Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaIKSp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 14:45:26 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:44257 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751148AbaIKSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 14:45:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:965:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2106:2196:2199:2393:2559:2562:2828:2899:2901:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:4385:4390:4395:5007:6117:6119:7652:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: key79_116493db8da02
X-Filterd-Recvd-Size: 3163
Message-ID: <1410461116.9942.15.camel@joe-AO725>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Joe Perches <joe@perches.com>
To: "J. German Rivera" <German.Rivera@freescale.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        stuart.yoder@freescale.com, Kim.Phillips@freescale.com,
        scottwood@freescale.com, agraf@suse.de,
        linuxppc-release@linux.freescale.net
Date: Thu, 11 Sep 2014 11:45:16 -0700
In-Reply-To: <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 12:34 -0500, J. German Rivera wrote:
> APIs to access the Management Complex (MC) hardware
> module of Freescale LS2 SoCs. This patch includes
> APIs to check the MC firmware version and to manipulate
> DPRC objects in the MC.

> diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
[]
> +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
> +{
> +	struct mc_command cmd = { 0 };
> +	int err;
> +
> +	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_GET_VERSION,
> +					  DPMNG_CMDSZ_GET_VERSION,
> +					  MC_CMD_PRI_LOW, 0);
> +
> +	err = mc_send_command(mc_io, &cmd);
> +	if (!err)
> +		DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);
> +
> +	return err;

I think it better style to read when the
failure case is handled immediately by
a return or a "goto out" and the successful
case code is at the same indent level

	err = mc_send_command_(etc...)
	if (err)
		return err;

	DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);

	return 0;
}

> diff --git a/drivers/bus/fsl-mc/dprc.c b/drivers/bus/fsl-mc/dprc.c

> +int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id)
> +{
> +	struct mc_command cmd = { 0 };
> +	int err;
> +
> +	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_CONT_ID,
> +					  DPRC_CMDSZ_GET_CONT_ID,
> +					  MC_CMD_PRI_LOW, 0);
> +
> +	err = mc_send_command(mc_io, &cmd);
> +	if (!err)
> +		DPRC_RSP_GET_CONTAINER_ID(cmd, *container_id);
> +
> +	return err;
> +}

Same sort of thing as above.
Actively fail on err and proceed at the same indent
level on success.

> +
> +int dprc_open(struct fsl_mc_io *mc_io, int container_id, uint16_t *dprc_handle)
> +{
> +	int err;
> +	struct mc_command cmd = { 0 };
> +
> +	cmd.header = mc_encode_cmd_header(MC_DPRC_CMDID_OPEN,
> +					  MC_CMD_OPEN_SIZE, MC_CMD_PRI_LOW, 0);
> +
> +	DPRC_CMD_OPEN(cmd, container_id);
> +
> +	err = mc_send_command(mc_io, &cmd);
> +	if (!err)
> +		*dprc_handle = MC_CMD_HDR_READ_AUTHID(cmd.header);
> +
> +	return err;
> +}

etc.

I didn't read any more.

