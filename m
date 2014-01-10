Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaAJMPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:15:44 -0500
Received: from mail.atsec.com ([195.30.99.214]:37406 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaAJMPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:15:41 -0500
From: Stephan Mueller <stephan.mueller@atsec.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Rafael Aquini <aquini@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH] char: random: stir the output pools differently when the random_write lenght allows splitting the seed
Date: Fri, 10 Jan 2014 13:15:34 +0100
Message-ID: <5743525.Bz4yhBJ8Tl@tauon>
Organization: atsec information security GmbH
User-Agent: KMail/4.11.4 (Linux/3.12.6-300.fc20.x86_64; KDE/4.11.4; x86_64; ; )
In-Reply-To: <52CFDB76.2030207@ladisch.de>
References: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com> <1510904.XsOZgVgixq@tauon> <52CFDB76.2030207@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Januar 2014, 12:37:26 schrieb Clemens Ladisch:

Hi Clemens,

>Stephan Mueller wrote:
>> Am Freitag, 10. Januar 2014, 09:13:57 schrieb Clemens Ladisch:
>>> Rafael Aquini wrote:
>>>> This patch introduces changes to the random_write method so it can
>>>> split the given seed and completely stir the output pools with
>>>> different halves of it, when seed lenght allows us doing so.
>>>> 
>>>> -	ret = write_pool(&blocking_pool, buffer, count);
>>>> +	ret = write_pool(pool1, buffer, count1);
>>>> 
>>>>  	if (ret)
>>>>  	
>>>>  		return ret;
>>>> 
>>>> -	ret = write_pool(&nonblocking_pool, buffer, count);
>>>> +	ret = write_pool(pool2, buffer + offset, count2);
>>> 
>>> Doesn't this assume that both halves of the buffer contain some
>>> (uncredited) entropy?  In other words, wouldn't this result in worse
>>> randomness for pool2 if the second half of the buffer contains just
>>> zero padding?
>> 
>> [...]
>> Coming back to your concern: sure, the caller can pad any data
>> injected into /dev/?random with zeros.
>
>Assume that the userspace of an embedded device wants to do the same
>kind of initialization that a call to add_device_randomness() does, and
>that it has some data like "char serial_number[256]".  The padding
>wouldn't be done intentionally, it's just a property of the data (and
>it wouldn't have mattered before this patch).
>
>> But as writing to the character files is allowed to every user, this
>> per definition must not matter (e.g. an attacker may simply write
>> zeros or other known data into the character file). And the random.c
>> driver handles that case appropriately by not increasing the entropy
>> estimator when receiving data.
>
>The problem is not with the entropy estimate.
>
>> All the patch tries to achieve is to ensure that both pools are not
>> always mixed with the same values.
>
>Before this patch, both pools got mixed with the same values.  After
>this patch, both pools indeed get mixed with different values, but now
>one pool gets mixed with a known value if one half of the buffer
>happens to be known.

Do you imply in your example above that the serial number is unknown? 
Anything that unprivileged user space tries to inject into /dev/?random 
should be considered data with known value.

Ciao
Stephan
