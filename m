Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaBLPv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:51:58 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47536 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaBLPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:51:53 -0500
MIME-Version: 1.0
In-Reply-To: <52FB5C87.50408@iogearbox.net>
References: <CAM83q7AiCBc5qSH18KhBHYknYf67Pnjkd3JUbC_WrBwefxHJMg@mail.gmail.com>
 <52FB5C87.50408@iogearbox.net>
From: Yuchung Cheng <ycheng@google.com>
Date: Wed, 12 Feb 2014 07:51:11 -0800
Message-ID: <CAK6E8=dRAdigL9LTodtvVSAiXxEDnG1UasiYW9PxmtqQmW1AxA@mail.gmail.com>
Subject: Re: Experimental Privacy Functions and TCP SYN Payloads
To: Daniel Borkmann <borkmann@iogearbox.net>
Cc: Quinn Wood <wood.quinn.s@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 3:35 AM, Daniel Borkmann <borkmann@iogearbox.net> wrote:
> (please cc netdev)
>
> On 02/12/2014 11:25 AM, Quinn Wood wrote:
>>
>> If program on host A spoofs the source address of an outgoing IPv4 packet
>> then
>> places that address in the first 32 bits of a UDP payload, a program on
>> host B
>> that is aware of these behaviors can still reply to the program on host A.
>> [1]
>>
>> Continuing with this approach the program on host A could encrypt the UDP
>> pay-
>> load in a way that the program on host B can decrypt, and effectively
>> reduce
>> the ability of others in the wide network to passively determine who host
>> A is
>> sending transmissions to while simultaneously ensuring the program on host
>> B
>> can respond to the program on host A. [2]
>>
>> I'm uncertain how to proceed if I want to use TCP for stateful
>> connections.
>> The requirement of a handshake before data is handed off to the program
>> means
>> this approach won't work out of the box. I'm looking for any insight folks
>> may
>> have regarding this.
>>
>> My original approach to the handshake included setting one of the reserved
>> bits in the TCP header to indicate the first 32 bits of the payload were
>> the
>> real source address. However this would be reliant on SYN packets
>> containing
>> a payload. Does the Linux kernel allow this?
For 3.7+ you can use TCP Fast Open.

For a quick trial experiment, you can just set
sysctl net.ipv4.tcp_fastopen=0x603 on both end hosts and use
sendmsg(..., MSG_FASTOPEN) instead of connect() then send(). the
sendmsg() will behave as a combo call of connect() and send() and
return similar errno. accept() will return after data in the SYN is
received instead of after handshake is completed.

>>
>> -
>>
>> [1] Barring any non store-and-forward network behavior like dropping
>> packets
>>      with questionable source addresses. Considering recent NTP-related
>> news
>>      this seems to be a not-entirely common activity :)
>> [2] This is of course reliant on both programs knowing the proper key for
>> the
>>      other.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
