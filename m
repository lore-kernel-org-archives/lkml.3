Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3JYOq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:46:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17789 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3JYOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:46:58 -0400
Date: Fri, 25 Oct 2013 17:45:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominik Paulus <dominik.paulus@fau.de>
Cc: Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: Re: [PATCHv4 10/16] staging: usbip: TLS for all userspace
 communication
Message-ID: <20131025144549.GG5871@mwanda>
References: <20130930123821.GI6192@mwanda>
 <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
 <1382193559-12549-11-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382193559-12549-11-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 04:39:13PM +0200, Dominik Paulus wrote:
> @@ -104,8 +105,10 @@ static int import_device(int sockfd, struct usbip_usb_device *udev)
>  		return -1;
>  	}
>  
> -	rc = usbip_vhci_attach_device(port, sockfd, udev->busnum,
> +	usbip_net_bye(conn);
> +	rc = usbip_vhci_attach_device(port, conn->sockfd, udev->busnum,
>  				      udev->devnum, udev->speed);
> +
>  	if (rc < 0) {

Don't put a blank line between the function call and the check.  They
logically are one idea.

>  
> -	rc = usbip_net_recv(sockfd, (void *) &reply, sizeof(reply));
> +	rc = usbip_net_recv(conn, (void *) &reply, sizeof(reply));

There is no need to cast to void here, btw.  That's just noise.

>  	do {
> -		if (sending)
> -			nbytes = send(sockfd, buff, bufflen, 0);
> +		if (!conn->have_crypto && sending)
> +			nbytes = send(conn->sockfd, buff, bufflen, 0);
> +		else if (!conn->have_crypto && !sending)
> +			nbytes = recv(conn->sockfd, buff, bufflen, MSG_WAITALL);
> +#ifdef HAVE_GNUTLS
> +		else if (sending)
> +			nbytes = gnutls_record_send(conn->session, buff, bufflen);
>  		else
> -			nbytes = recv(sockfd, buff, bufflen, MSG_WAITALL);
> +			nbytes = gnutls_record_recv(conn->session, buff, bufflen);
> +#else
> +		/*
> +		 * Assertion to let gcc be able to infer proper initialization
> +		 * of nbytes.
> +		 */
> +		assert(!conn->have_crypto);
> +#endif

This is messy and I feel like it should be abstracted into a function
so we can hide the ifdef in a header file.

		if (sending)
			nbytes = usbip_send(conn, buff, bufflen, 0);
		else
			nbytes = usbip_recv(...

We'd still have the ifdef but hidden away.


> +int usbip_net_srp_server_handshake(struct usbip_connection *conn)
> +{
> +	int ret;
> +
> +	if (gnutls_init(&conn->session, GNUTLS_SERVER) != 0)
> +		return -1;
> +	gnutls_priority_set_direct(conn->session, "NORMAL:-KX-ALL:+SRP", NULL);
> +	if (gnutls_credentials_set(conn->session, GNUTLS_CRD_SRP,
> +		usbip_net_srp_cred) != 0)
> +		return -1;
> +

Kernel style is more beautiful:

	ret = gnutls_credentials_set(conn->session, GNUTLS_CRD_SRP,
				     usbip_net_srp_cred);
	if (ret)
		return ret;

> +void usbip_net_bye(struct usbip_connection *conn)
> +{
> +#ifdef HAVE_GNUTLS
> +	if (conn->have_crypto) {
> +		gnutls_bye(conn->session, GNUTLS_SHUT_RDWR);
> +
> +		gnutls_deinit(conn->session);
> +		if (!conn->server)
> +			gnutls_srp_free_client_credentials(conn->srp_client_cred);
> +
> +		conn->have_crypto = 0;
> +	}
> +#else
> +	(void)conn;

What is this about?  I assume that GCC warns, but which version of GCC
are you using because that sounds horrible.

> +#endif

regards,
dan carpenter
