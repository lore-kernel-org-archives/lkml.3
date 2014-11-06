Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaKFRjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:39:42 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42369 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaKFRji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:39:38 -0500
MIME-Version: 1.0
In-Reply-To: <545A3ACC.3080101@redhat.com>
References: <1415069656-14138-1-git-send-email-ast@plumgrid.com>
	<1415069656-14138-2-git-send-email-ast@plumgrid.com>
	<54589B89.5000309@redhat.com>
	<CAMEtUuy5gJbeLqiSr1=SiNQ7WyqocUVV-siwhEnpBVqmzYzzCQ@mail.gmail.com>
	<545A3ACC.3080101@redhat.com>
Date: Thu, 6 Nov 2014 09:39:36 -0800
Message-ID: <CAMEtUuypNxy1ojYzn40oz5hAMsLEwOLR=rxf5CObksKqQcCF_Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] bpf: add 'flags' attribute to
 BPF_MAP_UPDATE_ELEM command
From: Alexei Starovoitov <ast@plumgrid.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 6:57 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 11/05/2014 12:04 AM, Alexei Starovoitov wrote:
>>
>> On Tue, Nov 4, 2014 at 1:25 AM, Daniel Borkmann <dborkman@redhat.com>
>> wrote:
>>>
>>> On 11/04/2014 03:54 AM, Alexei Starovoitov wrote:
>>>>
>>>>
>>>> the current meaning of BPF_MAP_UPDATE_ELEM syscall command is:
>>>> either update existing map element or create a new one.
>>>> Initially the plan was to add a new command to handle the case of
>>>> 'create new element if it didn't exist', but 'flags' style looks
>>>> cleaner and overall diff is much smaller (more code reused), so add
>>>> 'flags'
>>>> attribute to BPF_MAP_UPDATE_ELEM command with the following meaning:
>>>> enum {
>>>>     BPF_MAP_UPDATE_OR_CREATE = 0, /* add new element or update existing
>>>> */
>>>>     BPF_MAP_CREATE_ONLY,          /* add new element if it didn't exist
>>>> */
>>>>     BPF_MAP_UPDATE_ONLY           /* update existing element */
>>>> };
>>>
>>>
>>>  From you commit message/code I currently don't see an explanation why
>>> it cannot be done in typical ``flags style'' as various syscalls do,
>>> i.e. BPF_MAP_UPDATE_OR_CREATE rather represented as ...
>>>
>>>    BPF_MAP_CREATE | BPF_MAP_UPDATE
>>>
>>> Do you expect more than 64 different flags to be passed from user space
>>> for BPF_MAP?
>>
>>
>> several reasons:
>> - preserve flags==0 as default behavior
>> - avoid holes and extra checks for invalid combinations, so
>>    if (flags > BPF_MAP_UPDATE_ONLY) goto err, is enough.
>> - it looks much neater when user space uses
>>    BPF_MAP_UPDATE_OR_CREATE instead of ORing bits.
>>
>> Note this choice doesn't prevent adding bit-like flags
>> in the future. Today I cannot think of any new flags
>> for the update() command, but if somebody comes up with
>> a new selector that can apply to all three combinations,
>> we can add it as 3rd bit that can be ORed.
>
>
> Hm, mixing enums together with bitfield-like flags seems
> kind of hacky ... :/ Or, do you mean to say you're adding
> a 2nd flag field, i.e. splitting the 64bits into a 32bit
> ``cmd enum'' and 32bit ``flag section''?

something like this.
or splitting 64-bit into 2 and 62. We'll see.
First two encode this 'type' of update and the rest -
whatever else.

> Hm, my concern is that we start to add many *_OR_* enum
> elements once we find that a flag might be a useful in
> combination with many other flags ... even though if we
> only can think of 3 flags /right now/.

Agree. Adding many *_OR_* would look bad, that's
why I said that future additions can be bits. Like in
paragraph above.

Also, we don't have 3 flags now. In this patch I'm
showing 3 types and you're suggesting to treat
them as 2 flags. To me that's incorrect, since 'no flags'
becomes invalid combination, which logically incorrect.
Therefore I cannot see them as 'flags'. This is a 'type'
or 'style' of update() command.

I think it actually matches how open() defines things
in similar situation:
#define O_RDONLY        00000000
#define O_WRONLY        00000001
#define O_RDWR          00000002
We used to think of them as flags, but they're not
bit flags, though the rest of open() flags are bit-like.
If we apply your argument to open() then open()
should have defined O_RD as 1 and OR_WR as 2
and force everyone to mix and match them, but
then zero would be invalid. So I still think that
what I have is a cleaner API :)
