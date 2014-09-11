Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaIKKBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbaIKKBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:01:39 -0400
Message-ID: <541172E9.8070309@redhat.com>
Date: Thu, 11 Sep 2014 12:01:13 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-usb <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged command
 queuing
References: <540EC52C.3000804@redhat.com> <20140909152730.GA17882@infradead.org> <540FFBF4.9090001@redhat.com> <20140910154535.GA5102@infradead.org>
In-Reply-To: <20140910154535.GA5102@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/10/2014 05:45 PM, Christoph Hellwig wrote:
> On Wed, Sep 10, 2014 at 09:21:24AM +0200, Hans de Goede wrote:
>> I've applied the patch, this results in the following new dmesg output
>> when using uas:
>>
>> [  120.602632] initialized host-wide tag map!
>>
>> Thank you for looking into this.
> 
> So we're initializing the tag map, but scsi_activate_tcq doesn't pick it
> up.  I can't really come up with a good explanation for it, but there
> even without that there is an elephant in the room:  as part of the
> scsi-mq series I moved the bqt field used for this into a union with the
> new blk_mq_tag_set.  Below is a patch to get rid of that union, can you
> try if that fixes it?

Unfortunately that does not fix it :|

Regards,

Hans

> 
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index d0f69a3..bcffff2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -584,10 +584,8 @@ struct Scsi_Host {
>  	 * Area to keep a shared tag map (if needed, will be
>  	 * NULL if not).
>  	 */
> -	union {
> -		struct blk_queue_tag	*bqt;
> -		struct blk_mq_tag_set	tag_set;
> -	};
> +	struct blk_queue_tag	*bqt;
> +	struct blk_mq_tag_set	tag_set;
>  
>  	atomic_t host_busy;		   /* commands actually active on low-level */
>  	atomic_t host_blocked;
> 
