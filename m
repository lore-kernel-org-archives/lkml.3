Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaCGVsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:48:01 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43706 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaCGVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:47:59 -0500
Date: Fri, 07 Mar 2014 16:47:56 -0500 (EST)
Message-Id: <20140307.164756.1488071770631289333.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394170361-1043-1-git-send-email-kys@microsoft.com>
References: <1394170320-1002-1-git-send-email-kys@microsoft.com>
	<1394170361-1043-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 13:47:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Thu,  6 Mar 2014 21:32:36 -0800

> +static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
> +			struct hv_page_buffer *pb)
> +{
> +	int j = 0;
> +
> +	/* Deal with compund pages by ignoring unused part
> +	 * of the page.
> +	 */
> +	page += offset  >> PAGE_SHIFT;

Please only one space between "offset" and ">>"

> +	offset &= ~PAGE_MASK;
> +
> +	while (len > 0) {
> +		unsigned long bytes;
> +
> +		bytes = PAGE_SIZE - offset;
> +		if (bytes > len)
> +			bytes = len;
> +		pb[j].pfn = page_to_pfn(page);
> +		pb[j].offset = offset;
> +		pb[j].len = bytes;
> +
> +		offset += bytes;
> +		len -= bytes;
> +
> +		if (offset == PAGE_SIZE && len) {
> +			page++;
> +			offset = 0;
> +			j++;
> +		}
> +	}
> +
> +	return j + 1;
> +}

I think this function has some edge case errors.

As I understand it, this function returns how many page buffer entries
were filled in.

But if we fill exactly the end of a page, we will report one too many
in the return value.

Consider an "offset" of X, where X is smaller than PAGE_SIZE.  And a
"len" which is exactly "PAGE_SIZE - offset".

We will fill in exactly one page buffer entry, however we will
erroneously return 2 from this function.

I believe the fix is to first replace the test at the end of the loop
with:

	page++;
	offset = 0;
	j++;

And subsequently change the function to just return plain "j".
