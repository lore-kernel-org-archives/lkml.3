Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaAJLhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:37:34 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37480 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaAJLhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:37:32 -0500
X-Sasl-enc: N/QfwEVPGnkRZHXcOqM1yVixvkqQhNNfCMKCIA2YQYN9 1389353848
Message-ID: <52CFDB76.2030207@ladisch.de>
Date: Fri, 10 Jan 2014 12:37:26 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephan Mueller <stephan.mueller@atsec.com>
CC: Rafael Aquini <aquini@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH] char: random: stir the output pools differently when
 the random_write lenght allows splitting the seed
References: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com> <52CFABC5.5030806@ladisch.de> <1510904.XsOZgVgixq@tauon>
In-Reply-To: <1510904.XsOZgVgixq@tauon>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> Am Freitag, 10. Januar 2014, 09:13:57 schrieb Clemens Ladisch:
>> Rafael Aquini wrote:
>>> This patch introduces changes to the random_write method so it can
>>> split the given seed and completely stir the output pools with
>>> different halves of it, when seed lenght allows us doing so.
>>>
>>> -	ret = write_pool(&blocking_pool, buffer, count);
>>> +	ret = write_pool(pool1, buffer, count1);
>>>  	if (ret)
>>>  		return ret;
>>> -	ret = write_pool(&nonblocking_pool, buffer, count);
>>> +	ret = write_pool(pool2, buffer + offset, count2);
>>
>> Doesn't this assume that both halves of the buffer contain some
>> (uncredited) entropy?  In other words, wouldn't this result in worse
>> randomness for pool2 if the second half of the buffer contains just
>> zero padding?
>
> [...]
> Coming back to your concern: sure, the caller can pad any data injected
> into /dev/?random with zeros.

Assume that the userspace of an embedded device wants to do the same
kind of initialization that a call to add_device_randomness() does, and
that it has some data like "char serial_number[256]".  The padding
wouldn't be done intentionally, it's just a property of the data (and it
wouldn't have mattered before this patch).

> But as writing to the character files is allowed to every user, this
> per definition must not matter (e.g. an attacker may simply write
> zeros or other known data into the character file). And the random.c
> driver handles that case appropriately by not increasing the entropy
> estimator when receiving data.

The problem is not with the entropy estimate.

> All the patch tries to achieve is to ensure that both pools are not
> always mixed with the same values.

Before this patch, both pools got mixed with the same values.  After
this patch, both pools indeed get mixed with different values, but now
one pool gets mixed with a known value if one half of the buffer happens
to be known.


Regards,
Clemens
