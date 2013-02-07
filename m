Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3BGQpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:45:11 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33534 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3BGQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:45:09 -0500
MIME-Version: 1.0
In-Reply-To: <5113C818.9050307@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
 <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
 <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
 <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
 <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop>
 <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com>
 <1360186550.2650.4.camel@pasglop> <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com>
 <CACxGe6v3ZUEQhi764ivQqE9i2wGzJGcoC0sTVohb_6MQ9sE+hQ@mail.gmail.com>
 <5113C459.8000602@synopsys.com> <CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
 <5113C818.9050307@synopsys.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 7 Feb 2013 16:44:48 +0000
X-Google-Sender-Auth: 3h7T2uRRfrTJbA1lZv58TFNbkxc
Message-ID: <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 3:28 PM, Alexey Brodkin
<Alexey.Brodkin@synopsys.com> wrote:
> On 02/07/2013 07:23 PM, Grant Likely wrote:
>>
>> On Thu, Feb 7, 2013 at 3:12 PM, Alexey Brodkin
>> <Alexey.Brodkin@synopsys.com> wrote:
>>>
>>> On 02/07/2013 06:51 PM, Grant Likely wrote:
>>>>
>>>>
>>>> On Thu, Feb 7, 2013 at 2:39 PM, Grant Likely <grant.likely@secretlab.ca>
>>>> wrote:
>>>>>
>>>>>
>>>>> On Wed, Feb 6, 2013 at 9:35 PM, Benjamin Herrenschmidt
>>>>> <benh@kernel.crashing.org> wrote:
>>>>>>>
>>>>>>>
>>>>>>>    In fact, the driver already knows about this and figures
>>>>>>> out at runtime how the device is wired up to the bus. This is not the
>>>>>>> problem.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Except that this is very gross, especially when you observe that in
>>>>>> the
>>>>>> busted "big endian" case, it has to byteswap the bloody data port.
>>>>>>
>>>>>> So you end up having to do that gross hack with separate accessors for
>>>>>> registers vs. data and not able to use the _rep variants, which also
>>>>>> means that on platforms like ppc, you end up with a memory barrier on
>>>>>> every access (or more), which is going to slow things down enormously.
>>>>>
>>>>>
>>>>>
>>>>> I don't see why the _rep variants aren't usable here. The only reason
>>>>> I didn't use them when I wrote the driver in the first place was I was
>>>>> a n00b kernel hacker and I didn't know they were there.
>>>>
>>>>
>>>>
>>>> The 8-bit variant is different though because the hardware requires
>>>> pingponging between odd and even byte addresses to flush the fifo.
>>>> Reading a data port even address (0x40) gives the least significant
>>>> byte. Reading from an odd address (0x41) give the MSB and pops the
>>>> data off the FIFO. So, yes, the _rep variant can't be used in 8-bit
>>>> mode. It should still be fine in 16-bit.
>>>>
>>>> page 45:
>>>> http://www.xilinx.com/support/documentation/data_sheets/ds080.pdf
>>>>
>>>
>>> Ok, so may I do a re-spin with these changes:
>>
>>
>> There are two things here. 1) changing the accessors used. 2)
>> switching the endianess as a bug fix. Any changes to the endian access
>> should be a separate patch which a description of what is needed.
>>
>>> 1. In "ace_in_be16" use "ioread16be"
>>> 2. In "ace_out_be16" use "iowrite16be"
>>> 3. In "ace_in_le16" use "ioread16"
>>> 4. In "ace_out_le16" use "iowrite16"
>>
>>
>> Yes
>>
>>> 5. In "ace_datain_le16" use "ioread16_rep"
>>> 6. In "ace_dataout_le16" use "iowrite16_rep"
>>
>>
>> Maybe. In a separate patch. Hmmm... I guess there isn't an
>> ioread16be_rep variant. Oh well. Check first with Michal on LE
>> microblaze before making the change. If it doesn't work for him the
>> more understanding is needed. I was pretty sure the LE variant already
>> worked.
>>
>>> not sure about items for "ace_datain/out_be16" - what about _rep options
>>> here?
>>
>>
>> ioread16_rep should be fine. The ace_data{in,out}_be16 routines need
>> to use the LE accessor. The existing code is definitely correct in
>> this respect.
>
>
> Well, if "ioread16_rep" is used in both "ace_data{in,out}_be16" and
> "ace_data{in,out}_le16" then what is a difference between them?
> Whether there's a subtle difference still exists and I cannot see it or
> unified accessor could be used from now on at least for data access.

I've just spent some quality time with a piece of paper, and I think
I've figured it out...

Starting with register (non-data) access. The bus bindings are such
that on both BE and LE systems a native 16 bit read results in the
bits being in the correct order. On powerpc, you want to do a BE read
because the device appears as a BE device, and on LE systems a LE read
is wanted because that is how the device is wired. So far this makes
sense and matches the driver.

The same is true for the data port. A BE read does the right thing on
a BE platform, and LE read on a LE platform. (again, this is all about
bus attachment). However, the difference is what is then done with the
data.

For register reads, the driver uses the value directly. Either by
writing a 16 bit value to a register or reading and interpreting a 16
bit value. In both case the drive is directly interested in the 16bit
word

However, for the data port, the data is streamed out of the FIFO and
stored in memory for the block subsystem to use. A read from the data
port (assuming 'native' accesses are used as described above) obtains
16bits of data from the disk. Disk offsets are byte oriented, but
since it they are 16 bit reads, two bytes are read at a time:
First read:  offset 0 in LSB, offset 1 MSB
Second read: offset 2 in LSB, offset 3 in MSB
Third read: offset 4 in LSB, offset 5 in MSB

etc.

Then that data needs to be stored into memory. This is where things
are different with native 16 bit stores:
  On a BE memory system. MSB in byte address 0 and LSB in byte address 1.
  On a LE memory system. MSB in byte address 1 and LSB in byte address 0.

The block subsystem deals with byte oriented buffers; so given the way
data is arranged in the data port we want to always make sure the LSB
goes into address 0. The cause of problems isn't the BE vs LE bus
attachment. It is the different memory system orientation. Using
ioread16/iowrite16 has the right behaviour, but it's kind of a
backwards way to go about it.... It isn't that we want a be16_to_cpu()
or le16_to_cpu() on the data port read, but rather a cpu_to_le16() on
the store to memory regardless of the endianess of the platform.

So, if I'm correct that means that for the data port (specifically
copying between RAM and the data port) using ioread16/iowrite16 on the
data port results in the correct behaviour. It also means that LE
support in the current driver is broken.

The test will be whether or not your change works for LE microblaze
which I'm hoping Michal is going to take for a spin.

The ironic thing is that if the BE PPC/MB hardware engineers hadn't
swapped the bytelanes then we would *still* have to do special thinks
in the hardware; except it would be the data port accesses that would
need extra work, instead of the other registers.

g.
