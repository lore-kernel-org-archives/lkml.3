Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaACQXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:23:46 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26153 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbaACQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:23:20 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h1155h)
Message-ID: <52C6E2E9.6000309@Freescale.com>
Date: Fri, 3 Jan 2014 10:18:49 -0600
From: Emil Medve <Emilian.Medve@Freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Fix silent builds with make-4
References: <1386280583-2735-1-git-send-email-Emilian.Medve@Freescale.com> <52C6DEE0.20600@suse.cz>
In-Reply-To: <52C6DEE0.20600@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal,


On 01/03/2014 10:01 AM, Michal Marek wrote:
> On 2013-12-05 22:56, Emil Medve wrote:
>> make-4 changed the way/order it presents the command line options
>> into MAKEFLAGS
>>
>> In make-3.8x, '-s' would always be first into a group of options
>> with the '-'/hyphen removed
>>
>> $ make -p -s 2>/dev/null | grep ^MAKEFLAGS
>> MAKEFLAGS = sp
>>
>> In make-4, '-s' seems to always be last into a group of options
>> with the '-'/hyphen removed
>>
>> $ make -s -p 2>/dev/null | grep ^MAKEFLAGS
>> MAKEFLAGS = ps
>>
>> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
>> ---
>>  Makefile | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index 2c88e44..0332949 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -311,9 +311,15 @@ endif
>>  # If the user is running make -s (silent mode), suppress echoing of
>>  # commands
>>  
>> +ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
>> +ifneq ($(filter %s -s%,$(MAKEFLAGS)),)
> 
> The -s% here is unnecessary for two reasons: as you say, s is always at
> the end with make 4, and even if a long option is used, the hyphen is
> omitted:
> 
> 3.82:
> $ make -s -p --no-print-directory | grep MAKEFLAGS
> MAKEFLAGS =  --no-print-directory -sp

I was wondering how to account for the '-s%' pattern so I just preserved
it for make-4

> $ ./make/make -s -p --no-print-directory | grep MAKEFLAGS
> GNUMAKEFLAGS :=
> MAKEFLAGS = ps --no-print-directory
> 
> And according to
> http://git.savannah.gnu.org/cgit/make.git/commit/?id=a674abe702cc0c017209a3186c32df050ff21f41,
> the space character is always there, even if there are no single-letter
> options. So we can do something like
> 
> ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
> 
> and avoid accidentally matching things like --debug=jobs. Does the above
> work for you?

That's fine. I'll resubmit


Cheers,

