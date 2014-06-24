Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbaFXU7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:59:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaFXU7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:59:13 -0400
Date: Tue, 24 Jun 2014 16:59:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Don A. Bailey" <donb@securitymouse.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 49/61] lz4: ensure length does not wrap
Message-ID: <20140624205901.GA24603@kroah.com>
References: <20140624154952.751713761@linuxfoundation.org>
 <20140624154955.023232981@linuxfoundation.org>
 <CAFkuX4tQoRhsS2A5iJNWyMELs=sLhNx-m5Uq38R7fjSmGHfvvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFkuX4tQoRhsS2A5iJNWyMELs=sLhNx-m5Uq38R7fjSmGHfvvQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:28:31AM -0600, Don A. Bailey wrote:
> Objection. Patch needs slight adjustment. Emailing separately.
> 

Dragging this back to lkml, here's a proposed patch for this, I'll write
it up for "real" and submit it tomorrow.

thanks,

greg k-h

--------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: lz4: add additional checks



diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 99a03acb7d47..b74da447e81e 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -108,6 +108,8 @@ static int lz4_uncompress(const char *source, char *dest, int osize)
 		if (length == ML_MASK) {
 			for (; *ip == 255; length += 255)
 				ip++;
+			if (unlikely(length > (size_t)(length + *ip)))
+				goto _output_error;
 			length += *ip++;
 		}
 
@@ -157,7 +159,7 @@ static int lz4_uncompress(const char *source, char *dest, int osize)
 
 	/* write overflow error detected */
 _output_error:
-	return (int) (-(((char *)ip) - source));
+	return -1;
 }
 
 static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
