Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab3DXIjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:39:45 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:35480 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178Ab3DXIjk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:39:40 -0400
From: Loic PALLARDY <loic.pallardy@st.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: "Anna, Suman" <s-anna@ti.com>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 24 Apr 2013 10:39:05 +0200
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
Thread-Topic: [PATCHv3 00/14] drivers: mailbox: framework creation
Thread-Index: Ac5Axy6aPn67oeHEQ5iLDqYVLC516Q==
Message-ID: <51779A29.2040109@st.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
 <CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
 <37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
 <CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
 <37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
 <51778C3B.7010501@st.com>
 <CAJe_ZhfF93wWuUBktnt8eBnYR6fauUngViALuopfeiQ7P_N1uA@mail.gmail.com>
In-Reply-To: <CAJe_ZhfF93wWuUBktnt8eBnYR6fauUngViALuopfeiQ7P_N1uA@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On 04/24/2013 09:59 AM, Jassi Brar wrote:
> Hi Loic,
>
> On 24 April 2013 13:09, Loic PALLARDY<loic.pallardy@st.com>  wrote:
>> Hi Jassi, Suman,
>>
>> Yes, the xxx_no_irq API has been introduced to answer some STE
>> requirements. It must be possible to send some message under atomic
>> context for different reasons (latency, during idle/suspend procedures...).
>> This is not the best way to do, but the goal was to preserve TI legacy
>> in a first step. As explained by Suman, this patch series is coming from
>> the original TI mailbox framework and is modified step by step to fit
>> with all platforms.
>>
> IMHO a better way is to introduce a clean generically designed API and
> convert the existing drivers one at time. Let the TI drivers work as
> such for a while until someone converts them to the common API.
> Cloning and then complete organ transplantation seems a very
> inefficient way to have something new ;)
>
As explained in previous mail, it was not the decision taken during 
Linaro Copenhagen Connect to restart from scratch, mainly because only 
ST and TI were interested by such framework at the time being.

>>>>
>>>> (d) The 'struct mailbox_msg' should be just an opaque void* - the client/protocol
>>>> driver typecasts to void* the IPC controller specific message structure. API
>>>> shouldn't aim the impossible of providing a generic message format.
>>>
>>> The size parameter would still be needed. Depending on the h/w, it can be just an u32 or a series of bytes, and even in the latter case, it is not guaranteed that all messages transmitted will occupy the entire h/w shared memory data packet. I can see the current header field getting absorbed into the opaque void * structure for the ST mailbox driver. The size and ptr together provide a very generic message format.
>> That's something we discussed with Suman. The mailbox framework should
>> be independent from message format. Since mailbox could be base don a
>> shared mem or an hw fifo, message size is mandatory to transmit the
>> right number of data.
>>
> I too believe the "mailbox framework should be independent from
> message format" but _also_ that .size doesn't have to be a part of the
> standard format.
> Maybe it will help if I know what you guys mean by "shared mem" or an
> "hw fifo" mailbox?
>
Hw fifo means that you what a HW IP which contains x bytes fifo.
When you write one byte in the fifo, an interrupt is automatically 
raised and caught by coprocessor which should read fifo on its side to 
empty it. In that case, Tx RTR is mandatory.
Shared mem, means that mailbox is made up of a cross interrupt + a 
status register (may be optional) + a shared memory in which messages 
are exchanged.
After writing message in shared mem, CPU has to raise the cross 
interrupt itself. In case flow control is less important...

/Loic
> Thanks
> -Jassi