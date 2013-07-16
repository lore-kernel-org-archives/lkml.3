Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3GPKOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:14:33 -0400
Received: from bosmailout18.eigbox.net ([66.96.186.18]:59217 "EHLO
	bosmailout18.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3GPKOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:14:31 -0400
X-Greylist: delayed 2389 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2013 06:14:30 EDT
X-Authority-Analysis: v=2.0 cv=dt1Z+ic4 c=1 sm=1
 a=mze3Iowvsrioyt7kijtP+A==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=OYGCgI3rE0kA:10 a=8nJEP1OIZ-IA:10 a=8Ne1j35meV0A:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=nV4eVqW96EqPj3Hu3QcA:9 a=wPNLvfGTeEIA:10
 a=x8qw8EAkfcRkIpZA8Q87Bg==:117
X-EN-OrigOutIP: 10.20.18.7
X-EN-IMPSID: 0xag1m004099BUA01xagUH
Message-ID: <51E5137B.7000302@yahoo.es>
Date: Tue, 16 Jul 2013 17:33:47 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Tony Lindgren <tony@atomide.com>, linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
References: <51E50217.1000507@yahoo.es> <20130716090300.GG8880@arwen.pp.htv.fi>
In-Reply-To: <20130716090300.GG8880@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.227
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/2013 5:03 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jul 16, 2013 at 04:19:35PM +0800, Hein Tibosch wrote:
>> Hi Vikram,
>>
>> On a OMAP4460, i2c-bus-3:
>>
>> A driver (lm75) is causing many 'timeout waiting for bus ready' errors.
>> SDA remains high (as it should), but SCL remains low after a NACK.
>> The bus becomes _unusable for other clients_.
>>
>> While probing, "lm75" writes a command, followed by a read + stop,
>> but the write command is NACK'd. The chip does accept other writes/reads,
>> it just refuses to ack invalid commands.
>>
>> Can you tell me if the patch below would make any sense? Or is it the
>> responsibility of the client to reset the i2c_smbus?
> patch below breaks repeated start.
Hi,

No, after the NACK, no more commands are being processed,
including a repeated start. omap_i2c_xfer() returns -EREMOTEIO
without ever freeing the bus.

The bus is left in an impossible state with SCL constantly low
and all next commands (to different chips) will therefore get
a -ETIMEDOUT

With this patch, the bus will become idle again and new commands
can be processed normally

Hein

