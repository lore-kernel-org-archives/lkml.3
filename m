Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174Ab3IDRdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:33:11 -0400
Received: from mail-bn1lp0157.outbound.protection.outlook.com ([207.46.163.157]:47814
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab3IDRdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:33:09 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation
 code for util services
Thread-Topic: [PATCH 1/1] Drivers: hv: util: Fix a bug in version
 negotiation code for util services
Thread-Index: AQHOd0UKrHFKHj6YF0aFkGvHNZstGZm1/vYAgAATQACAACbAYA==
Date: Wed, 4 Sep 2013 17:33:03 +0000
Message-ID: <615470dba26b432fa041a02678395e2c@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1372786290-12641-1-git-send-email-kys@microsoft.com>
 <20130904135754.GA2010@aepfle.de> <20130904150648.GA9162@aepfle.de>
In-Reply-To: <20130904150648.GA9162@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::4]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(13464003)(24454002)(377454003)(51704005)(80022001)(31966008)(81342001)(50986001)(47976001)(54316002)(56776001)(69226001)(59766001)(77982001)(49866001)(74706001)(56816003)(19580395003)(77096001)(47736001)(74876001)(79102001)(65816001)(74316001)(74662001)(81542001)(81816001)(47446002)(74502001)(19580405001)(76576001)(76482001)(83322001)(33646001)(551934002)(76796001)(76786001)(51856001)(74366001)(4396001)(81686001)(46102001)(63696002)(83072001)(80976001)(54356001)(53806001)(3826001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ed43::4;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r84HXZmQ024524



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Wednesday, September 04, 2013 8:07 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: hv: util: Fix a bug in version negotiation code for
> util services
> 
> On Wed, Sep 04, Olaf Hering wrote:
> 
> > I suggest to let callers deal with error handling. Also as a cleanup,
> > vmbus_prep_negotiate_resp does not make use of the negop passed to it.
> > So that arg can be removed.
> 
> Simplify vmbus_prep_negotiate_resp. If we take the optimistic approach
> that negotiation will not fail for any of the callers of
> vmbus_prep_negotiate_resp this patch on top of yours should fix 2008 and
> 2012r2.
Thanks Olaf. I would prefer that we explicitly fail the negotiations than assume that it will succeed.
Essentially, I want the same behavior as what we had before but only for the final version being
negotiated. If it is ok with you, I can spin up the patch and send it out.

Regards,

K. Y

> 
> Olaf
> 
> ---
>  drivers/hv/channel_mgmt.c | 22 +++++++++-------------
>  drivers/hv/hv_kvp.c       |  8 ++++----
>  drivers/hv/hv_snapshot.c  |  3 +--
>  drivers/hv/hv_util.c      |  7 +++----
>  include/linux/hyperv.h    |  4 +---
>  5 files changed, 18 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 12ec8c8..dcaad3e 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -41,7 +41,6 @@ struct vmbus_channel_message_table_entry {
>  /**
>   * vmbus_prep_negotiate_resp() - Create default response for Hyper-V
> Negotiate message
>   * @icmsghdrp: Pointer to msg header structure
> - * @icmsg_negotiate: Pointer to negotiate message structure
>   * @buf: Raw buffer channel data
>   *
>   * @icmsghdrp is of type &struct icmsg_hdr.
> @@ -54,10 +53,10 @@ struct vmbus_channel_message_table_entry {
>   *
>   * Mainly used by Hyper-V drivers.
>   */
> -bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp,
> -				struct icmsg_negotiate *negop, u8 *buf,
> +bool vmbus_prep_negotiate_resp(struct icmsg_hdr *icmsghdrp, u8 *buf,
>  				int fw_version, int srv_version)
>  {
> +	struct icmsg_negotiate *negop;
>  	int icframe_major, icframe_minor;
>  	int icmsg_major, icmsg_minor;
>  	int fw_major, fw_minor;
> @@ -65,7 +64,6 @@ bool vmbus_prep_negotiate_resp(struct icmsg_hdr
> *icmsghdrp,
>  	int i;
>  	bool found_match = false;
> 
> -	icmsghdrp->icmsgsize = 0x10;
>  	fw_major = (fw_version >> 16);
>  	fw_minor = (fw_version & 0xFFFF);
> 
> @@ -116,19 +114,17 @@ bool vmbus_prep_negotiate_resp(struct icmsg_hdr
> *icmsghdrp,
>  	 * version numbers we can support.
>  	 */
> 
> -fw_error:
> -	if (!found_match) {
> -		negop->icframe_vercnt = 0;
> -		negop->icmsg_vercnt = 0;
> -	} else {
> +	if (found_match) {
> +		icmsghdrp->icmsgsize = 0x10;
>  		negop->icframe_vercnt = 1;
>  		negop->icmsg_vercnt = 1;
> +		negop->icversion_data[0].major = icframe_major;
> +		negop->icversion_data[0].minor = icframe_minor;
> +		negop->icversion_data[1].major = icmsg_major;
> +		negop->icversion_data[1].minor = icmsg_minor;
>  	}
> 
> -	negop->icversion_data[0].major = icframe_major;
> -	negop->icversion_data[0].minor = icframe_minor;
> -	negop->icversion_data[1].major = icmsg_major;
> -	negop->icversion_data[1].minor = icmsg_minor;
> +fw_error:
>  	return found_match;
>  }
> 
> diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
> index 5312720..31e338a 100644
> --- a/drivers/hv/hv_kvp.c
> +++ b/drivers/hv/hv_kvp.c
> @@ -584,7 +584,6 @@ void hv_kvp_onchannelcallback(void *context)
>  	struct hv_kvp_msg *kvp_msg;
> 
>  	struct icmsg_hdr *icmsghdrp;
> -	struct icmsg_negotiate *negop = NULL;
> 
>  	if (kvp_transaction.active) {
>  		/*
> @@ -607,14 +606,15 @@ void hv_kvp_onchannelcallback(void *context)
>  			 * We start with win8 version and if the host cannot
>  			 * support that we use the previous version.
>  			 */
> -			if (vmbus_prep_negotiate_resp(icmsghdrp, negop,
> +			if (vmbus_prep_negotiate_resp(icmsghdrp,
>  				 recv_buffer, UTIL_FW_MAJOR_MINOR,
>  				 WIN8_SRV_MAJOR_MINOR))
>  				goto done;
> 
> -			vmbus_prep_negotiate_resp(icmsghdrp, negop,
> +			if (vmbus_prep_negotiate_resp(icmsghdrp,
>  				 recv_buffer, UTIL_FW_MAJOR_MINOR,
> -				 WIN7_SRV_MAJOR_MINOR);
> +				 WIN7_SRV_MAJOR_MINOR))
> +				goto done;
> 
>  		} else {
>  			kvp_msg = (struct hv_kvp_msg *)&recv_buffer[
> diff --git a/drivers/hv/hv_snapshot.c b/drivers/hv/hv_snapshot.c
> index e4572f3..51e8203 100644
> --- a/drivers/hv/hv_snapshot.c
> +++ b/drivers/hv/hv_snapshot.c
> @@ -170,7 +170,6 @@ void hv_vss_onchannelcallback(void *context)
> 
> 
>  	struct icmsg_hdr *icmsghdrp;
> -	struct icmsg_negotiate *negop = NULL;
> 
>  	if (vss_transaction.active) {
>  		/*
> @@ -189,7 +188,7 @@ void hv_vss_onchannelcallback(void *context)
>  			sizeof(struct vmbuspipe_hdr)];
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> -			vmbus_prep_negotiate_resp(icmsghdrp, negop,
> +			vmbus_prep_negotiate_resp(icmsghdrp,
>  				 recv_buffer, UTIL_FW_MAJOR_MINOR,
>  				 VSS_MAJOR_MINOR);
>  		} else {
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index c16164d..01d7b17 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -88,7 +88,6 @@ static void shutdown_onchannelcallback(void *context)
>  	struct shutdown_msg_data *shutdown_msg;
> 
>  	struct icmsg_hdr *icmsghdrp;
> -	struct icmsg_negotiate *negop = NULL;
> 
>  	vmbus_recvpacket(channel, shut_txf_buf,
>  			 PAGE_SIZE, &recvlen, &requestid);
> @@ -98,7 +97,7 @@ static void shutdown_onchannelcallback(void *context)
>  			sizeof(struct vmbuspipe_hdr)];
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> -			vmbus_prep_negotiate_resp(icmsghdrp, negop,
> +			vmbus_prep_negotiate_resp(icmsghdrp,
>  					shut_txf_buf, UTIL_FW_MAJOR_MINOR,
>  					SHUTDOWN_MAJOR_MINOR);
>  		} else {
> @@ -225,7 +224,7 @@ static void timesync_onchannelcallback(void *context)
>  				sizeof(struct vmbuspipe_hdr)];
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> -			vmbus_prep_negotiate_resp(icmsghdrp, NULL,
> time_txf_buf,
> +			vmbus_prep_negotiate_resp(icmsghdrp, time_txf_buf,
>  						UTIL_FW_MAJOR_MINOR,
>  						TIMESYNCH_MAJOR_MINOR);
>  		} else {
> @@ -266,7 +265,7 @@ static void heartbeat_onchannelcallback(void *context)
>  				sizeof(struct vmbuspipe_hdr)];
> 
>  		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> -			vmbus_prep_negotiate_resp(icmsghdrp, NULL,
> +			vmbus_prep_negotiate_resp(icmsghdrp,
>  				hbeat_txf_buf, UTIL_FW_MAJOR_MINOR,
>  				HEARTBEAT_MAJOR_MINOR);
>  		} else {
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 4994907..084a858 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1502,9 +1502,7 @@ struct hyperv_service_callback {
>  };
> 
>  #define MAX_SRV_VER	0x7ffffff
> -extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *,
> -					struct icmsg_negotiate *, u8 *, int,
> -					int);
> +extern bool vmbus_prep_negotiate_resp(struct icmsg_hdr *, u8 *, int, int);
> 
>  int hv_kvp_init(struct hv_util_service *);
>  void hv_kvp_deinit(void);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
