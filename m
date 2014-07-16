Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246AbaGPOeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:34:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58559 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934406AbaGPOeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:34:16 -0400
Message-ID: <53C68D64.4010702@arm.com>
Date: Wed, 16 Jul 2014 15:34:12 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "courtney.cavin@sonymobile.com" <courtney.cavin@sonymobile.com>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "slapdau@yahoo.com.au" <slapdau@yahoo.com.au>,
        "lftan.linux@gmail.com" <lftan.linux@gmail.com>,
        "loic.pallardy@st.com" <loic.pallardy@st.com>,
        "s-anna@ti.com" <s-anna@ti.com>,
        "ashwin.chaugule@linaro.org" <ashwin.chaugule@linaro.org>,
        "bjorn@kryo.se" <bjorn@kryo.se>,
        "patches@linaro.org" <patches@linaro.org>,
        "Mollie.Wu@tw.fujitsu.com" <Mollie.Wu@tw.fujitsu.com>,
        "t.takinishi@jp.fujitsu.com" <t.takinishi@jp.fujitsu.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <5461658.P0nNPHkj0L@wuerfel> <CAJe_Zhdtzhv=1QfhCAu6G_nq0VqW9v6TvgHSJe9VmgJQwo0U3Q@mail.gmail.com> <5214160.a78RDYzY5T@wuerfel>
In-Reply-To: <5214160.a78RDYzY5T@wuerfel>
X-OriginalArrivalTime: 16 Jul 2014 14:34:10.0961 (UTC) FILETIME=[021F4010:01CFA103]
X-MC-Unique: 114071615341311301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/07/14 15:08, Arnd Bergmann wrote:
> On Wednesday 16 July 2014 18:42:22 Jassi Brar wrote:
>> On 16 July 2014 18:39, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Wednesday 16 July 2014 18:35:33 Jassi Brar wrote:
>>>> On 16 July 2014 18:15, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> On Wednesday 16 July 2014 18:07:04 Jassi Brar wrote:
>>>>>> On 16 July 2014 15:46, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>>>> On Wednesday 16 July 2014 10:40:19 Sudeep Holla wrote:
>>>>>>>>> +
>>>>>>>>> +Required property:
>>>>>>>>> +- mbox: List of phandle and mailbox channel specifier.
>>>>>>>>> +
>>>>>>>>> +- mbox-names: List of identifier strings for each mailbox channel
>>>>>>>>> +               required by the client.
>>>>>>>>> +
>>>>>>>>
>>>>>>>> IMO the mailbox names are more associated with the controller channels/
>>>>>>>> mailbox rather than the clients using it. Does it make sense to move
>>>>>>>> this under controller. It also avoid each client replicating the names.
>>>>>>>
>>>>>>> I think it would be best to just make the mbox-names property optional,
>>>>>>> like we have for other subsystems.
>>>>>>>
>>>>>> A very similar subsystem - DMAEngine also has 'dma-names' as a
>>>>>> required property.
>>>>>>
>>>>>> If a client is assigned only 1 mbox in DT, we can do without
>>>>>> mbox-names. But I am not sure what to do if a client needs two or more
>>>>>> differently capable mboxes? Simply allocating in order of mbox request
>>>>>> doesn't seem very robust.
>>>>>
>>>>> Traditionally, these things (regs, interrupts, ...) are just accessed
>>>>> by index. The reason why dmaengine requires the name is that some machines
>>>>> can use multiple DMA engine devices attached to the same request line,
>>>>> so the dmaengine subsystem can pick any of them that has a matching
>>>>> name.
>>>> And also, I think, when a client needs 2 different dma channels, say
>>>> for RX and TX each. The api can't assign the first channel specified
>>>> in 'dmas' property to the first channel request that comes to it,
>>>> unless we assume client driver always requests dma channels in the
>>>> order written in its DT node.  And this is the main reason I see for
>>>> having mbox-names property.
>>>
>>> Most subsystems require passing an explicit index in this case.
>>>
>>>>    If we make mbox-names optional, do we assume client driver must
>>>> request mbox in the order specified in its DT node?
>>>
>>> Correct.
>>>
>> OK. So how about we drop mbox-names altogether and expect client
>> driver to simply provide an index of the mbox needed?
>
> That would be fine with me, but I think a lot of people like
> the idea of identifying things by name, and are used to that
> from the other subsystems.
>
> Maybe you can leave the mbox-names property defined as 'optional'
> in the generic mbox binding but remove the code in Linux? That way
> we can always put it back at a later point without changing the
> binding in an incompatible way.
>
> Individual mailbox clients can mandate specific strings.

This sounds reasonable to me.

Regards,
Sudeep

