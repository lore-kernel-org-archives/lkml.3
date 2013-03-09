Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab3CIDrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 22:47:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35865 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760295Ab3CIDrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 22:47:00 -0500
Date: Sat, 09 Mar 2013 12:46:33 +0900 (JST)
Message-Id: <20130309.124633.504064737.d.hatayama@jp.fujitsu.com>
To: zhangyanfei.yes@gmail.com
Cc: heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        zhangyanfei@cn.fujitsu.com, akpm@linux-foundation.org, cpw@sgi.com,
        vgoyal@redhat.com
Subject: Re: [PATCH v2 15/20] kexec: fill note buffers by NT_VMCORE_PAD
 notes in page-size boundary
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <CANBD6kFwTjKL9CqUzVSWFSRH6ibdQstCU5wTBkv4+=4HhPiG4Q@mail.gmail.com>
References: <513867D2.7090501@cn.fujitsu.com>
	<20130308.105519.82764856.d.hatayama@jp.fujitsu.com>
	<CANBD6kFwTjKL9CqUzVSWFSRH6ibdQstCU5wTBkv4+=4HhPiG4Q@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanfei Zhang <zhangyanfei.yes@gmail.com>
Subject: Re: [PATCH v2 15/20] kexec: fill note buffers by NT_VMCORE_PAD notes in page-size boundary
Date: Fri, 8 Mar 2013 21:02:50 +0800

> 2013/3/8 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>:
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> Subject: Re: [PATCH v2 15/20] kexec: fill note buffers by NT_VMCORE_PAD notes in page-size boundary
>> Date: Thu, 7 Mar 2013 18:11:30 +0800
>>
>>> 于 2013年03月02日 16:37, HATAYAMA Daisuke 写道:
>>>> Fill both crash_notes and vmcoreinfo_note buffers by NT_VMCORE_PAD
>>>> note type to make them satisfy mmap()'s page-size boundary
>>>> requirement.
>>>>
>>>> So far, end of note segments has been marked by zero-filled elf
>>>> header. Instead, this patch writes NT_VMCORE_PAD note in the end of
>>>> note segments until the offset on page-size boundary.
>>>
>>>
>>> In the codes below, it seems that you assign name "VMCOREINFO" for
>>> note type NT_VMCORE_PAD, right? This is kind of wired, i think. This
>>> name has been used for NT_VMCORE_DEBUGINFO note already. Why not something
>>> like "VMCOREPAD" or "PAD"?
>>>
>>
>> It looks you are confusing or don't know name and type. The name is
>> namespace and in the namespace, there are multiple note types, each of
>> which has the corresponding data. In other words, data corresponding
>> to types differ if they belong to differnet name space even if
>> integers of the types are coincide with.
> 
> Yes, I knew this. Just as the spec said " a program must recognize both the name
> and the type to recognize a descriptor.". But I cannot understand what your word
> "namespace" came from? I think you complicate simple things here.
> 
> Only with a type, we cannot recognize a descriptor, because "multiple
> interpretations of
> a single type value may exist", So we should combine the name and the type
> together. If both the name and type of two descriptors are the same,
> we could say we
> have two same descriptors. If one of them (type or name) are
> different, we say the
> two descriptors are different and the two notes have different data.
> 
> If I am wrong, please correct me.

??? I think you're saying here the same thing as my explanation above.

Although the term ''name space'' never occurs in ELF, it seems to me
standard to represent the same values as different ones by combining
additional elements as names to them.

Well, formally, it is represented as simply tuples or vector
space. For example, support set S and S' and define new set S x S' by

  S x S' := { (s, s') | s in S, s' in S' }

and equality of the S x S' are defined as usual:

  (s1, s1') == (s2, s2') iff s1 == s2 and s1' == s2'.

In ELF, S is names and S' is types. There's no other formal meaning
there.

>>
>> The "VMCOREINFO" name represents information exported from
>> /proc/vmcore that is used in kdump framework. In this sense,
>> NT_VMCORE_PAD that is specific for /proc/vmcore and kdump framework,
>> should belong to the "VMCOREINFO" name.
> 
> I cannot understand the name explanation totally. Does the name really
> have this meaning? Is there any authentic document? I was always thinking we
> could feel free to name a name by ourselves!

Of course, it's optional for you to decide how to name notes within
the mechanism. But it's important to treat naming for ease of managing
note types. In addition to the above formal definition, it's important
to consider what name gives us. It's readability, telling us that note
types that belong to unique name are treated in common in the sense of
the name. This is apart from the formal definition above.

It's certainly possible to distinguish notes by giving names only and
not giving types. For example, imagine there are new 27 notes and they
have different names but have 0 as type.

name          type
"SOME_NOTE_A" 0
"SOME_NOTE_B" 0
...
"SOME_NOTE_Z" 0

Also, for example,

name        type
"SOME_NOTE" 0     => NT_SOME_NOTE_A
"SOME_NOTE" 1     => NT_SOME_NOTE_B
...
"SOME_NOTE" 26    => NT_SOME_NOTE_Z

For the former case, it *looks to me* that space of time is not used
effectively and it *looks to me* that space of name is not consumed
efficiently.

After all, it amounts to individual preference about naming. I cannot
say anything more.

Thanks.
HATAYAMA, Daisuke

