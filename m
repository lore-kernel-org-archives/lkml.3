Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3JQMJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:09:49 -0400
Received: from mailrelay-out2.netcologne.de ([81.173.193.132]:43451 "EHLO
	mailrelay-out2.netcologne.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222Ab3JQMJr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:09:47 -0400
From: =?iso-8859-1?Q?Kelleter=2C_G=FCnther?= <GKelleter@datus.com>
To: Andrew Hendry <andrew.hendry@gmail.com>,
        David Laight <David.Laight@aculab.com>
CC: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X.25: Fix address field length calculation
Thread-Topic: [PATCH] X.25: Fix address field length calculation
Thread-Index: AQHOybLnty+s/FnB5kKUVGTJOhUv65n142AAgAEC2gCAAbWDgIAAEs8A
Date: Thu, 17 Oct 2013 12:09:33 +0000
Message-ID: <525FD37C.50003@datus.com>
References: <525D5131.9070007@datus.com>
	<1381858190.22110.25.camel@joe-AO722>
	<AE90C24D6B3A694183C094C60CF0A2F6026B738F@saturn3.aculab.com>
 <CADo0ohh7jZhc_WJFkrYYxoYza8ZeSEadzwgwabJWwQ1TucdCcg@mail.gmail.com>
In-Reply-To: <CADo0ohh7jZhc_WJFkrYYxoYza8ZeSEadzwgwabJWwQ1TucdCcg@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.52.21.9]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <50211790EE7DB34C981F36D3D8EAF8C1@datus.local>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-purgate-ID: 153929::1382011783-00000593-E037872B/0-0/0-0
X-purgate: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


E.g. called address 7 digits and caller address 3 digits. Called DCE
answering without facilities
gives us this packet (hex):

37 12 34 56 71 23 00

then x25_parse_address_block()  tries to pull 1+7+3 = 11 bytes from the
packet (with pskb_may_pull())
which only has 7 bytes.
When facilities are included the wrong calculated length has no effect
since the facilities make this packet long enough to make pskb_may_pull
with wrong number
of bytes succeed. later x25_addr_ntoa() correctly pulls 6 bytes for
addresses from the packet.


Am 17.10.2013 13:02, schrieb Andrew Hendry:
> Sorry for the previous html mail.
> This appears to be correct, what length addresses are you getting back
> in the call accept when this happens?
>
> On Wed, Oct 16, 2013 at 7:56 PM, David Laight <David.Laight@aculab.com> wrote:
>>> On Tue, 2013-10-15 at 14:29 +0000, Kelleter, Günther wrote:
>>>> Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.
>>> []
>>>> Wrong length calculation leads to rejection of CALL ACCEPT packets.
>>> []
>>>> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
>>> []
>>>> @@ -98,7 +98,7 @@ int x25_parse_address_block(struct sk_buff *skb,
>>>>     }
>>>>     len = *skb->data;
>>>> -   needed = 1 + (len >> 4) + (len & 0x0f);
>>>> +   needed = 1 + ((len >> 4) + (len & 0x0f) + 1) / 2;
>>> This calculation looks odd.
>> Looks correct to me...
>> In X.25 the lengths (in digits) of the called and calling addresses
>> are encoded in the high and low nibbles of one byte and then
>> followed by both addresses with a digit in each nibble.
>> If the length of the first address is odd, the second one
>> isn't byte aligned.
>>
>>         David
>>
>>
>>


-- 
