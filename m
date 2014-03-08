Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaCHGhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 01:37:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47507 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaCHGhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 01:37:00 -0500
Date: Sat, 08 Mar 2014 01:36:58 -0500 (EST)
Message-Id: <20140308.013658.918013334851017662.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
From: David Miller <davem@davemloft.net>
In-Reply-To: <fd6bb08bd9a447aa9c0da3b584ea9bb8@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394170361-1043-1-git-send-email-kys@microsoft.com>
	<20140307.164756.1488071770631289333.davem@davemloft.net>
	<fd6bb08bd9a447aa9c0da3b584ea9bb8@BY2PR03MB299.namprd03.prod.outlook.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 22:37:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KY Srinivasan <kys@microsoft.com>
Date: Sat, 8 Mar 2014 04:12:01 +0000

> 
> 
>> -----Original Message-----
>> From: David Miller [mailto:davem@davemloft.net]
>> Sent: Saturday, March 8, 2014 3:18 AM
>> To: KY Srinivasan
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> jasowang@redhat.com
>> Subject: Re: [PATCH V2 1/6] Drivers: net: hyperv: Enable scatter gather I/O
>> 
>> From: "K. Y. Srinivasan" <kys@microsoft.com>
>> Date: Thu,  6 Mar 2014 21:32:36 -0800
>> 
>> > +static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
>> > +			struct hv_page_buffer *pb)
>> > +{
>> > +	int j = 0;
>> > +
>> > +	/* Deal with compund pages by ignoring unused part
>> > +	 * of the page.
>> > +	 */
>> > +	page += offset  >> PAGE_SHIFT;
>> 
>> Please only one space between "offset" and ">>"
>> 
>> > +	offset &= ~PAGE_MASK;
>> > +
>> > +	while (len > 0) {
>> > +		unsigned long bytes;
>> > +
>> > +		bytes = PAGE_SIZE - offset;
>> > +		if (bytes > len)
>> > +			bytes = len;
>> > +		pb[j].pfn = page_to_pfn(page);
>> > +		pb[j].offset = offset;
>> > +		pb[j].len = bytes;
>> > +
>> > +		offset += bytes;
>> > +		len -= bytes;
>> > +
>> > +		if (offset == PAGE_SIZE && len) {
>> > +			page++;
>> > +			offset = 0;
>> > +			j++;
>> > +		}
>> > +	}
>> > +
>> > +	return j + 1;
>> > +}
>> 
>> I think this function has some edge case errors.
>> 
>> As I understand it, this function returns how many page buffer entries were
>> filled in.
>> 
>> But if we fill exactly the end of a page, we will report one too many in the
>> return value.
> 
> I may be missing something here; but in the case you are describing we would return a value
> of one as we should. When offset + len is exactly equal to the page size, we would not increment
> the value of j, since at that point len == 0. Since the initial value of j was 0 and we return (j + 1),
> we will return 1.

That's not what happens, you execute the loop code at least once, and
hit:

>> > +		if (offset == PAGE_SIZE && len) {
>> > +			page++;
>> > +			offset = 0;
>> > +			j++;
>> > +		}

thus incrementing j before the return statement.
