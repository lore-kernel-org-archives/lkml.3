Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab3HGN1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:27:11 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:53598
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932990Ab3HGN1G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:27:06 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC102.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(51704005)(199002)(189002)(13464003)(377454003)(80976001)(47446002)(50986001)(54356001)(83072001)(47976001)(4396001)(19580405001)(79102001)(53806001)(81542001)(51856001)(16406001)(47736001)(83322001)(59766001)(76786001)(31966008)(66066001)(80022001)(74316001)(74662001)(81342001)(74366001)(49866001)(19580395003)(63696002)(76576001)(77096001)(46102001)(56816003)(65816001)(56776001)(74876001)(74706001)(76482001)(77982001)(54316002)(33646001)(69226001)(74502001)(76796001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;A:1;MX:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Tools: hv: correct payload size in netlink_send
Thread-Topic: [PATCH] Tools: hv: correct payload size in netlink_send
Thread-Index: AQHOk28qBIQ83Ws79kWz/4PTah6F6pmJu3hg
Date: Wed, 7 Aug 2013 13:26:33 +0000
Message-ID: <fa3fb59894d045fa929feb151e0a1138@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1375880841-12959-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1375880841-12959-1-git-send-email-olaf@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0931CB1479
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB063.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC102.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC102.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Wednesday, August 07, 2013 9:07 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org; Olaf Hering
> Subject: [PATCH] Tools: hv: correct payload size in netlink_send
> 
> netlink_send is supposed to send just the cn_msg+hv_kvp_msg via netlink.
> Currently it sets an incorrect iovec size, as reported by valgrind.
> 
> In the case of registering with the kernel the allocated buffer is large
> enough to hold nlmsghdr+cn_msg+hv_kvp_msg, no overrun happens. In the
> case of responding to the kernel the cn_msg is located in the middle of
> recv_buffer, after the nlmsghdr. Currently the code in netlink_send adds
> also the size of nlmsghdr to the payload. But nlmsghdr is a separate
> iovec. This leads to an (harmless) out-of-bounds access when the kernel
> processes the iovec. Correct the iovec size of the cn_msg to be just
> cn_msg + its payload.

Thanks Olaf.

> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

> ---
>  tools/hv/hv_kvp_daemon.c | 2 +-
>  tools/hv/hv_vss_daemon.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index d3bcb84..1bd1ad1 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1399,7 +1399,7 @@ netlink_send(int fd, struct cn_msg *msg)
>  	char buffer[64];
>  	struct iovec iov[2];
> 
> -	size = NLMSG_SPACE(sizeof(struct cn_msg) + msg->len);
> +	size = sizeof(struct cn_msg) + msg->len;
> 
>  	nlh = (struct nlmsghdr *)buffer;
>  	nlh->nlmsg_seq = 0;
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index 6b4f2fa..2f1f53f 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -111,7 +111,7 @@ static int netlink_send(int fd, struct cn_msg *msg)
>  	char buffer[64];
>  	struct iovec iov[2];
> 
> -	size = NLMSG_SPACE(sizeof(struct cn_msg) + msg->len);
> +	size = sizeof(struct cn_msg) + msg->len;
> 
>  	nlh = (struct nlmsghdr *)buffer;
>  	nlh->nlmsg_seq = 0;



