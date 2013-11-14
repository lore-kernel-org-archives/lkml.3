Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3KNRps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:45:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41320 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab3KNRpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:45:42 -0500
Message-ID: <52850C28.8010800@zytor.com>
Date: Thu, 14 Nov 2013 09:45:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>,
        Pavel Roskin <proski@gnu.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: [PATCH 2/2] x86: Add support for uncompressed kernel images
References: <20131114083247.GB9687@ab42.lan> <1384418296-10374-2-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1384418296-10374-2-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 12:38 AM, Christian Ruppert wrote:
> diff --git a/lib/decompress_copy.c b/lib/decompress_copy.c
> new file mode 100644
> index 0000000..8a41090
> --- /dev/null
> +++ b/lib/decompress_copy.c
> @@ -0,0 +1,47 @@
> +#include <linux/decompress/mm.h>
> +
> +#define NOZIP_BUFSZ (16 * 1024)
> +STATIC int INIT nozip(unsigned char *buf, int len,
> +			int(*fill)(void*, unsigned int),
> +			int(*flush)(void*, unsigned int),
> +			unsigned char *outbuf,
> +			int *pos,
> +			void(*error)(char *x))
> +{
> +	char *b;
> +
> +	if (buf)
> +		b = buf;
> +	else
> +		b = malloc(NOZIP_BUFSZ);
> +
> +	if (!b) {
> +		error("Out of memory while allocating buffer");
> +		return -1;
> +	}
> +
> +	if (flush) {
> +		if (!len)
> +			len = fill(b, NOZIP_BUFSZ);
> +
> +		len = flush(b, len);
> +	} else {
> +		if (!len)
> +			len = fill(outbuf, NOZIP_BUFSZ);
> +		else {
> +			int i;
> +			for (i = 0; i < len; i++)
> +				outbuf[i] = b[i];

Clever way of doing memcpy().  I know some other compression
implementations open-code memmove(), but using it for the entire data
set in the most common case is atrocious.  If we need to get a default
implementation of memmove() we should just do that.

	-hpa

