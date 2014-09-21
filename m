Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbaIUMtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 08:49:09 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:43128 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbaIUMtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 08:49:07 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2014 08:49:07 EDT
X-RRZE-Submit-IP: 2001:a60:f0c5:0:16da:e9ff:feee:da1
Date: Sun, 21 Sep 2014 14:43:41 +0200
From: Dominik Paulus <dominik.paulus@fau.de>
To: Max Vozeler <max@hinterhof.net>
Cc: Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@vger.kernel.org, valentina.manea.m@gmail.com,
        shuah.kh@samsung.com, gregkh@linuxfoundation.org,
        Dominik Paulus <dominik.paulus@fau.de>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Subject: Re: [PATCH 02/18] usbip: Add support for client authentication
Message-ID: <20140921124340.GB2097@d-paulus.de>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
 <1410910735-27929-3-git-send-email-maximilian@eschenbacher.email>
 <20140921004259.GA23120@x201t.vpn.hinterhof.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140921004259.GA23120@x201t.vpn.hinterhof.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for your feedback!

On Sun, Sep 21, 2014 at 02:42:59AM +0200, Max Vozeler wrote:
> > +	if (strcmp(username, "dummyuser"))
> > +		/* User invalid, stored dummy data in g and n. */
> > +		return 1;
> 
> Could you describe the role of "dummyuser" in a comment? It seems to be
> a placeholder for GnuTLS SRP requiring a username.

It is, SRP is designed for username/password authentication, but we only
do password.

> 
> > +	return 0;
> > +}
> > +
> > +int usbip_net_init_gnutls(void)
> > +{
> > +	int ret;
> > +
> > +	gnutls_global_init();
> > +
> > +	usbip_net_srp_salt.data = gnutls_malloc(16);
> 
> This should be freed somewhere.

Actually, it is used for the whole lifetime of the process.

> > +	/*
> > +	 * Process opcodes. We might receive more than one, as the
> > +	 * client might send STARTTLS first
> > +	 */
> > +	while (cont) {
> > +		uint16_t code = OP_UNSPEC;
> >  
> > -	if (ret == 0)
> > -		info("request %#0x(%d): complete", code, connfd);
> > -	else
> > -		info("request %#0x(%d): failed", code, connfd);
> > +		ret = usbip_net_recv_op_common(connfd, &code);
> > +		if (ret < 0) {
> > +			dbg("could not receive opcode: %#0x", code);
> > +			return -1;
> > +		}
> > +
> > +		info("received request: %#0x(%d)", code, connfd);
> > +
> > +		/* We require an authenticated encryption */
> > +		if (!auth && code != OP_REQ_STARTTLS) {
> > +			usbip_net_send_op_common(connfd, OP_REPLY, ST_NA);
> > +			return -1;
> > +		}
> > +
> > +		switch (code) {
> > +#ifdef HAVE_GNUTLS
> > +		case OP_REQ_STARTTLS:
> > +			if (!need_auth) {
> > +				ret = -1;
> > +				err("Unexpected TLS handshake attempt (client uses password, server doesn't)");
> > +			} else {
> > +				ret = net_srp_server_handshake(connfd);
> > +				if (ret != 0)
> > +					err("TLS handshake failed");
> > +				auth = 1;
> 
> This marks the connection as authenticated even if the handshake has
> failed, which doesn't seem right.
> 
> The err() used here is a macro that merely logs the error and moves
> on. It does not exit() like the err.h err() functions.
> 
> So this should probably be
> 
> > +				if (ret != 0)
> > +					err("TLS handshake failed");
> 				else
> > +					auth = 1;
> 
> instead?

It might be even better to just drop the connection after a failed
handshake, as existing clients aren't going to do more than one
authentication attempt, anyway.

Note that - after patch 11/18 has been applied, too -
net_srp_server_handshake() sets the "have_crypto" flag on the connection
handle, thus, all subsequent network operations are going to fail
anyway, as no TLS session has been established. Thus, the incorrectly
set "auth" flag doesn't have any security implications here.

Regards,
Dominik
