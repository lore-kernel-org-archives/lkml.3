Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaLPK1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:27:11 -0500
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:54213 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbaLPK1J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:27:09 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <549008F7.9060206@topic.nl>
Date: Tue, 16 Dec 2014 11:27:03 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drivers/regulator/core.c: Don't print error on EPROBE_DEFER
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl> <20141209161420.GJ1934@sirena.org.uk> <54873B8E.1060106@topic.nl> <20141209184817.GH11764@sirena.org.uk>
In-Reply-To: <20141209184817.GH11764@sirena.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 12/09/2014 07:48 PM, Mark Brown wrote:
> On Tue, Dec 09, 2014 at 07:12:30PM +0100, Mike Looijmans wrote:
>> On 12/09/2014 05:14 PM, Mark Brown wrote:
>
>>>> If a regulator depends on another regulator that happens to be called
>>>> later, the kernel always prints a message like this:
>>>>   reg-fixed-voltage regulator_sd1: Failed to find supply vin
>>>> Since the deferral is not something fatal, nor even something the user
>>>> may need to be aware about, reduce the message to debug level.
>
>> Can we instead at least reduce it to WARN or INFO level then?
>
> You appear to have deleted my reply here...  one problem with your
> suggestion is that it means we have to special case all error handling
> on probe for deferral which isn't wonderful.

(Sorry for deleting your reply. It wasn't intentional though.)

special casing deferral may not be "wonderful", but it is what currently 
happens in many places, and it's just "the best we can do for now". A similar 
patch for MMC got approval:
https://lkml.org/lkml/2014/10/27/477

>> I have to explain over and over again that there's no problem when that
>> message comes along ten times in a row. And it causes people to overlook the
>> messages that really are errors.
>
> Can we do something with the log message that triggers on probe
> deferral?  There tends to be a learning curve with probe deferral but
> the fact that it's generally extremely noisy tends to be useful - I
> usually point people at that (not just in the context at regulators) and
> tell them not to worry unless debugging.

Using "dev_err" is not really "tell them not to worry unless debugging", I 
think that is what "dev_dbg" was meant to do.

The only real solution I could come up with here is to replace "return 
-EPROBE_DEFER" with something that stores the current stack, registers the 
resource it requires and jumps back to where the driver probe originated. Once 
the resource is available, the stored stack is resumed and then the probe code 
path can continue as if nothing bad happened. This would also deliver 
excellent diagnostic data in case the resource remains absent. I've built 
something like this in Python which has a "yield" statement one can use for 
this purpose. It's a bit tougher to do in C I guess. So until then, we're 
stuck with sprinkling "if (ret == -EPROBE_DEFER)" code snippets all over the 
place.




Met vriendelijke groet / kind regards,

Mike Looijmans
System Expert


TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Topic zoekt gedreven (embedded) software specialisten!
http://topic.nl/vacatures/topic-zoekt-software-engineers/

