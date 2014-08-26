Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbaHZIxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:53:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933987AbaHZIxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:53:34 -0400
Message-ID: <53FC4B0C.8040604@suse.de>
Date: Tue, 26 Aug 2014 10:53:32 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <94D0CD8314A33A4D9D801C0FE68B402958C1A9E5@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C1A9E5@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 02:39 AM, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Yoshihiro YUNOMAE
>> Sent: Friday, 08 August, 2014 6:50 AM
>> Subject: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
>> error messages on trace
> ...
>> 1) printk
>> Keeps current implemntation of upstream kernel.
>> The messages are divided and can be mixed, but all users can
>> check the error messages without any settings.
>
> scsi_io_completion ignore the scsi_logging_level and always calls
> printk if it detects ACTION_FAIL, resulting in messages like:
>
>      [10240.338600] sd 2:0:0:0: [sdr]
>      [10240.339722] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>      [10240.341662] sd 2:0:0:0: [sdr]
>      [10240.342792] Sense Key : Hardware Error [current]
>      [10240.344575] sd 2:0:0:0: [sdr]
>      [10240.345653] Add. Sense: Logical unit failure
>      [10240.347138] sd 2:0:0:0: [sdr] CDB:
>      [10240.348309] Read(10): 28 00 00 00 00 80 00 00 08 00
>
> If you trigger hundreds of errors (e.g., hot remove a device
> during heavy IO), then all the prints to the linux serial console
> bog down the system, causing timeouts in commands to other
> devices and soft lockups for applications.
>
> Some changes that would help are:
> 1. Put them under SCSI logging level control
> 2. Use printk_ratelimited so an excessive number are trimmed
>
> Would you like to include something like this in your
> patch set?
>
> This is an example patch that only prints them if the MLCOMPLETE
> logging level is nonzero.
> Off: scsi_logging_level --set --mlcomplete=0
> On: scsi_logging_level --set --mlcomplete=1
>
> Some other loglevel (e.g., ERROR_RECOVERY) could be used.
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d6b4ea8..dbb601f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1037,7 +1037,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>   	switch (action) {
>   	case ACTION_FAIL:
>   		/* Give up and fail the remainder of the request */
> -		if (!(req->cmd_flags & REQ_QUIET)) {
> +		if (!(req->cmd_flags & REQ_QUIET) &&
> +		    SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
> +		    SCSI_LOG_MLCOMPLETE_BITS)) {
>   			scsi_print_result(cmd);
>   			if (driver_byte(result) & DRIVER_SENSE)
>   				scsi_print_sense("", cmd);
>
> Converting to printk_ratelimited is harder since the prints
> are spread out over three functions (and as your patch
> series notes, many individual printk calls).  The rates
> for the printk calls might not match, which would lead to
> even more confusing output.
>
Good point. Will be including it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
