Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3HYQNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 12:13:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37579 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab3HYQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 12:13:16 -0400
Date: Sun, 25 Aug 2013 18:13:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 07/18] asymmetric keys: explicitly add the leading zero
 byte to encoded message
Message-ID: <20130825161313.GD5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-8-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-8-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-08-22 19:01:46, Lee, Chun-Yi wrote:
> Per PKCS1 spec, the EMSA-PKCS1-v1_5 encoded message is leading by 0x00 0x01 in
> its first 2 bytes. The leading zero byte is suppressed by MPI so we pass a
> pointer to the _preceding_ byte to RSA_verify() in original code, but it has
> risk for the byte is not zero because it's not in EM buffer's scope, neither
> RSA_verify() nor mpi_get_buffer() didn't take care the leading byte.
> 
> To avoid the risk, that's better we explicitly add the leading zero byte to EM
> for pass to RSA_verify(). This patch allocate a _EM buffer to capture the
> result from RSA_I2OSP(), then set the first byte to zero in EM and copy the
> remaining bytes from _EM.
> 
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

> -	ret = RSA_verify(H, EM - 1, k, sig->digest_size,
> +	EM = kmalloc(k, GFP_KERNEL);
> +	memset(EM, 0, 1);
> +	memcpy(EM + 1, _EM, k-1);
> +	kfree(_EM);

Spot a crash waiting to happen.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
