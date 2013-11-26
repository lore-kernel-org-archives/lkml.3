Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3KZJgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:36:45 -0500
Received: from atl4mhob01.myregisteredsite.com ([209.17.115.39]:47796 "EHLO
	atl4mhob01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592Ab3KZJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:36:42 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
Message-ID: <52946BA6.3080308@topic.nl>
Date: Tue, 26 Nov 2013 10:36:38 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
References: <1385447520-3306-1-git-send-email-mike.looijmans@topic.nl> <20131126090639.GA2568@katana>
In-Reply-To: <20131126090639.GA2568@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:06 AM, Wolfram Sang wrote:
> On Tue, Nov 26, 2013 at 07:32:00AM +0100, Mike Looijmans wrote:
>> Leaving the mux enabled causes needless I2C traffic on the downstream
>> bus. De-selecting after every request causes excess I2C traffic and
>> switching.
>>
>> This patch implements a hybrid solution: After 200ms of inactivity,
>> the mux is disabled.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>
> You still haven't answered my initial question. Also, please don't
> resend without saying what changed since the last version.

Sorry, I never received the patch mail nor any replies into my own mailbox, so 
I assumed the message was never actually sent (probably our mail server 
considered it spam). I found it online though, so I'll try to answer your 
questions now.

Michael Lawnick:
 > Have you checked against behavior on cascaded muxes?

No, I didn't even realize it was at all possible to cascade muxes. And you're 
right, this patch will break those.

Would it be acceptable if I made the timeout optional, by making the 
"deselect_on_exit" boolean into a three-state value (off, on, timeout)? Or, 
alternatively, implement "deselect_on_exit" using the timeout scheme (probably 
with a very short timeout)?


Wolfram Sang:
 > This is a bus. Why is this bad?

My customer has two reasons for wanting this change:

The extra I2C traffic consumes extra power. If the bus is terminated using 2k 
resistors, approximately 1mA of current (assuming ~2V signals) is flowing when 
the bus is pulled low. On low power designs, this extra power consumption is 
noticable. There is no way to turn the mux "off" from either user or kernel 
space. The signals going through the mux to a place where no I2C device is 
actually listening are only wasting power.

The I2C signals are used to control sensitive codecs. When looking at the 
sampled data, the I2C traffic is visible in the captured analog signal. To 
prevent this from happening, the mux can be disabled whenever not 
communicating with the codec. This could be accomplished with the 
"deselect_on_exit" boolean, but because audio driver sends the codec 
parameters in dozens of small transactions, this will result in a lot more 
needless I2C traffic, constantly switching the mux for each codec setting.


Kind regards,

Mike.
