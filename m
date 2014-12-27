Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaL3Nd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:33:27 -0500
Received: from p01c11o141.mxlogic.net ([208.65.144.64]:32944 "EHLO
	p01c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaL3NdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:33:25 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 08:33:25 EST
X-MXL-Hash: 54a2a9a53dd2f5d9-1d4931f38770fae283f582537ae4fb4306544faf
X-MXL-Hash: 54a2a7ad188c75c0-8b3c9709a2c10133ffa8bcb425551f05284307d2
Message-ID: <549EE319.9030702@stratus.com>
Date: Sat, 27 Dec 2014 11:49:29 -0500
From: Joe Lawrence <joe.lawrence@stratus.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
CC: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <MPT-FusionLinux.pdl@avagotech.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [SCSI RFC] mpt2sas: wait_for_completion_timeout timeout not reported
References: <1419873954-22573-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419873954-22573-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [134.111.23.94]
X-AnalysisOut: [v=2.1 cv=fNIt3Pqe c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=rkJuIV0pGx0A:10 a=2Om]
X-AnalysisOut: [6y6CD4YAA:10 a=BLceEmwcHowA:10 a=N659UExz7-8A:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=A92cGCtB03wA:10 a=YTpflxMAgTkqE]
X-AnalysisOut: [r13hQQA:9 a=pILNOxqGKmIA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014123004); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2014 12:25 PM, Nicholas Mc Guire wrote:
> wait_for_completion_timeout reaching timeout was being ignored,
> this probably also should fail if timeout condition occurs ?
> 
> this was only compile tested with
> x86_64_defconfig + CONFIG_SCSI_LOWLEVEL=y + CONFIG_SCSI_MPT2SAS=m
> 
> patch is against linux-next 3.19.0-rc1 -next-20141226
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_config.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
> index c72a2ff..02dc2d8 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_config.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
> @@ -391,7 +391,7 @@ _config_request(struct MPT2SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
>  	mpt2sas_base_put_smid_default(ioc, smid);
>  	timeleft = wait_for_completion_timeout(&ioc->config_cmds.done,
>  	    timeout*HZ);
> -	if (!(ioc->config_cmds.status & MPT2_CMD_COMPLETE)) {
> +	if (timeleft == 0 || !(ioc->config_cmds.status & MPT2_CMD_COMPLETE)) {
>  		printk(MPT2SAS_ERR_FMT "%s: timeout\n",
>  		    ioc->name, __func__);
>  		_debug_dump_mf(mpi_request,
> 

Hi Nicholas,

This would look like the correct thing to do here, for it eliminates a
small window where we timeout when mpt2sas_config_done had set
MPT2_CMD_COMPLETE and MPT3_CMD_REPLY_VALID, but has not finished copying
the reply data into config_cmds.reply.

It looks like the same patch should be applied to the mpt3sas driver as
well.

-- Joe
