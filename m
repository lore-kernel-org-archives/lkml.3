Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3KOJuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:50:01 -0500
Received: from mail.abilis.ch ([195.70.19.74]:15091 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590Ab3KOJtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:49:53 -0500
Date: Fri, 15 Nov 2013 10:49:33 +0100
From: Christian Ruppert <christian.ruppert@abilis.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Roskin <proski@gnu.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: [PATCH 2/2] x86: Add support for uncompressed kernel images
Message-ID: <20131115094931.GB31656@ab42.lan>
References: <20131114083247.GB9687@ab42.lan>
 <1384418296-10374-2-git-send-email-christian.ruppert@abilis.com>
 <52850C28.8010800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52850C28.8010800@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 09:45:12AM -0800, H. Peter Anvin wrote:
> On 11/14/2013 12:38 AM, Christian Ruppert wrote:
> > diff --git a/lib/decompress_copy.c b/lib/decompress_copy.c
> > new file mode 100644
> > index 0000000..8a41090
> > --- /dev/null
> > +++ b/lib/decompress_copy.c
> > @@ -0,0 +1,47 @@
> > +#include <linux/decompress/mm.h>
> > +
> > +#define NOZIP_BUFSZ (16 * 1024)
> > +STATIC int INIT nozip(unsigned char *buf, int len,
> > +			int(*fill)(void*, unsigned int),
> > +			int(*flush)(void*, unsigned int),
> > +			unsigned char *outbuf,
> > +			int *pos,
> > +			void(*error)(char *x))
> > +{
> > +	char *b;
> > +
> > +	if (buf)
> > +		b = buf;
> > +	else
> > +		b = malloc(NOZIP_BUFSZ);
> > +
> > +	if (!b) {
> > +		error("Out of memory while allocating buffer");
> > +		return -1;
> > +	}
> > +
> > +	if (flush) {
> > +		if (!len)
> > +			len = fill(b, NOZIP_BUFSZ);
> > +
> > +		len = flush(b, len);
> > +	} else {
> > +		if (!len)
> > +			len = fill(outbuf, NOZIP_BUFSZ);
> > +		else {
> > +			int i;
> > +			for (i = 0; i < len; i++)
> > +				outbuf[i] = b[i];
> 
> Clever way of doing memcpy().  I know some other compression
> implementations open-code memmove(), but using it for the entire data
> set in the most common case is atrocious.  If we need to get a default
> implementation of memmove() we should just do that.

Actually, the x86 architecture already contains a basic implementation
of memcpy in its self-decompressor. Correct me if I'm wrong but I guess
memmove is not required since I don't expect the output of a generic
decompression function to overlap with its input.

We can simply use that function if we agree that
. either nozip is x86 specific
. or every architecture using this code must bring along its own memcpy
  implementation in its self-decompressor.

Do you think that would be OK?

Greetings,
  Christian
