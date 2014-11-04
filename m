Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaKDXEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:04:37 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37197 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKDXEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:04:35 -0500
MIME-Version: 1.0
In-Reply-To: <54589B89.5000309@redhat.com>
References: <1415069656-14138-1-git-send-email-ast@plumgrid.com>
	<1415069656-14138-2-git-send-email-ast@plumgrid.com>
	<54589B89.5000309@redhat.com>
Date: Tue, 4 Nov 2014 15:04:34 -0800
Message-ID: <CAMEtUuy5gJbeLqiSr1=SiNQ7WyqocUVV-siwhEnpBVqmzYzzCQ@mail.gmail.com>
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

On Tue, Nov 4, 2014 at 1:25 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
>
> On 11/04/2014 03:54 AM, Alexei Starovoitov wrote:
>>
>> the current meaning of BPF_MAP_UPDATE_ELEM syscall command is:
>> either update existing map element or create a new one.
>> Initially the plan was to add a new command to handle the case of
>> 'create new element if it didn't exist', but 'flags' style looks
>> cleaner and overall diff is much smaller (more code reused), so add 'flags'
>> attribute to BPF_MAP_UPDATE_ELEM command with the following meaning:
>> enum {
>>    BPF_MAP_UPDATE_OR_CREATE = 0, /* add new element or update existing */
>>    BPF_MAP_CREATE_ONLY,          /* add new element if it didn't exist */
>>    BPF_MAP_UPDATE_ONLY           /* update existing element */
>> };
>
>
> From you commit message/code I currently don't see an explanation why
> it cannot be done in typical ``flags style'' as various syscalls do,
> i.e. BPF_MAP_UPDATE_OR_CREATE rather represented as ...
>
>   BPF_MAP_CREATE | BPF_MAP_UPDATE
>
> Do you expect more than 64 different flags to be passed from user space
> for BPF_MAP?

several reasons:
- preserve flags==0 as default behavior
- avoid holes and extra checks for invalid combinations, so
  if (flags > BPF_MAP_UPDATE_ONLY) goto err, is enough.
- it looks much neater when user space uses
  BPF_MAP_UPDATE_OR_CREATE instead of ORing bits.

Note this choice doesn't prevent adding bit-like flags
in the future. Today I cannot think of any new flags
for the update() command, but if somebody comes up with
a new selector that can apply to all three combinations,
we can add it as 3rd bit that can be ORed.
Default will stay zero and 'if >' check in older
kernels will seamlessly work with new userspace.
I don't like holes in flags and combinatorial
explosion of bits and checks for them unless
absolutely necessary.
