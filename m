Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaGHTfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:35:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63406 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaGHTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:35:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140707.193505.345276817146527821.davem@davemloft.net>
References: <0f692012238337f2c40893319830ae042523ce18.1404172155.git.decot@googlers.com>
 <cover.1404172155.git.decot@googlers.com> <f98ccbfee35a7ab7f9499ede9b34e6b1120d88f1.1404172155.git.decot@googlers.com>
 <20140707.193505.345276817146527821.davem@davemloft.net>
From: David Decotigny <decot@googlers.com>
Date: Tue, 8 Jul 2014 12:35:14 -0700
Message-ID: <CAG88wWZ9GiqoOscqG4-ePOWo8bXgSTAQ6=6-tZPahMcxOvQMLg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/2] netpoll: avoid reference leaks
To: David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <edumazet@google.com>, amwang@redhat.com,
        antonio@meshcoding.com, Jiri Pirko <jpirko@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the feedback. This patch results from manual inspection of
the code. I agree my commit description is abusive: in the case of
bonding, I think everything is fine, there should be no ref leak,
cleanup paths seem clean.

My point was to make things more predictable: ndo_netpoll_cleanup
called anyways to acknowledge actual loss of a ref to npinfo,
irrespective of whether it's the last ref or not. Without this patch,
calling ndo_netpoll_cleanup would depend on some timing behavior, hard
to predict, and users of the API have better be careful to reclaim the
refs manually anyways: as a consequence, not sure this callback is
actually required in its current inception.

On Mon, Jul 7, 2014 at 7:35 PM, David Miller <davem@davemloft.net> wrote:
> From: David Decotigny <decot@googlers.com>
> Date: Mon, 30 Jun 2014 16:50:10 -0700
>
>> This ensures that the ndo_netpoll_cleanup callback is called for every
>> device that provides one. Otherwise there is a risk of reference leak
>> with bonding for example, which depends on this callback to cleanup
>> the slaves' references to netpoll info.
>>
>> Tested:
>>   see patch "netpoll: fix use after free"
>>
>> Signed-off-by: David Decotigny <decot@googlers.com>
>
> I definitely don't understand this.
>
> Why would we call the cleanup function of an object before it's
> reference count hits zero?  It is exactly the act of reaching a
> zero refcount which should trigger invoking the cleanup callback.
>
> If a refcount is being released in another location without checking
> if it hits zero and invoking the cleanup if so, _THAT_ is the bug.
