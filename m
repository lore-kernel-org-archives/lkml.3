Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaAJJ5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:57:23 -0500
Received: from mail.atsec.com ([195.30.99.214]:35345 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaAJJ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:57:21 -0500
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2014 04:57:21 EST
From: Stephan Mueller <stephan.mueller@atsec.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Rafael Aquini <aquini@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH] char: random: stir the output pools differently when the random_write lenght allows splitting the seed
Date: Fri, 10 Jan 2014 10:49:14 +0100
Message-ID: <1510904.XsOZgVgixq@tauon>
Organization: atsec information security GmbH
User-Agent: KMail/4.11.4 (Linux/3.12.6-300.fc20.x86_64; KDE/4.11.4; x86_64; ; )
In-Reply-To: <52CFABC5.5030806@ladisch.de>
References: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com> <52CFABC5.5030806@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Januar 2014, 09:13:57 schrieb Clemens Ladisch:

Hi Clemens,

>Rafael Aquini wrote:
>> This patch introduces changes to the random_write method so it can
>> split the given seed and completely stir the output pools with
>> different halves of it, when seed lenght allows us doing so.
>> 
>> -	ret = write_pool(&blocking_pool, buffer, count);
>> +	ret = write_pool(pool1, buffer, count1);
>> 
>>  	if (ret)
>>  	
>>  		return ret;
>> 
>> -	ret = write_pool(&nonblocking_pool, buffer, count);
>> +	ret = write_pool(pool2, buffer + offset, count2);
>
>Doesn't this assume that both halves of the buffer contain some
>(uncredited) entropy?  In other words, wouldn't this result in worse
>randomness for pool2 if the second half of the buffer contains just
>zero padding?

The concern this patch addresses is the following:

Both pools have dissimilar use cases. Typically, the blocking_pool is 
used for cases where more "secure" random numbers shall be generated 
whereas the nonblocking_pool shall be used for any other case.

The issue now is that both pools intended for different use cases are 
always updated with the same data. That means, we effectively have two 
different RNGs (the blocking and nonblocking pool) which are both 
(re-)seeded with the same data every time when invoking a write on 
/dev/?random.

There is no way that the (re)seed operation mixes both pools with 
different values.

Coming back to your concern: sure, the caller can pad any data injected 
into /dev/?random with zeros. But as writing to the character files is 
allowed to every user, this per definition must not matter (e.g. an 
attacker may simply write zeros or other known data into the character 
file). And the random.c driver handles that case appropriately by not 
increasing the entropy estimator when receiving data. All the patch 
tries to achieve is to ensure that both pools are not always mixed with 
the same values. Hence, the patch does not change the entropy estimator 
operation.

Ciao
Stephan
