Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043Ab3IDPkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934868Ab3IDPkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:40:33 -0400
Message-ID: <52275463.4020206@redhat.com>
Date: Wed, 04 Sep 2013 17:40:19 +0200
From: =?UTF-8?B?SmFuIEthbHXFvmE=?= <jkaluza@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Guy Briggs <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, davem@davemloft.net,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        eparis@redhat.com, tj@kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>  <1378275261-4553-1-git-send-email-jkaluza@redhat.com>  <878uzdf2xp.fsf@xmission.com> <20130904145830.GC28517@madcap2.tricolour.ca>  <20130904152022.GD28517@madcap2.tricolour.ca> <1378308621.7360.110.camel@edumazet-glaptop>
In-Reply-To: <1378308621.7360.110.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 05:30 PM, Eric Dumazet wrote:
> On Wed, 2013-09-04 at 11:20 -0400, Richard Guy Briggs wrote:
>> On Wed, Sep 04, 2013 at 10:58:30AM -0400, Richard Guy Briggs wrote:
>>> On Wed, Sep 04, 2013 at 12:42:26AM -0700, Eric W. Biederman wrote:
>>>> Jan Kaluza <jkaluza@redhat.com> writes:
>>>>> this patchset against net-next (applies also to linux-next) adds 3 new types
>>>>> of "Socket"-level control message (SCM_AUDIT, SCM_PROCINFO and SCM_CGROUP).
>>>
>>>> By my count you have overflowed cb in struct sk_buff and are stomping on
>>>> _skb_refdest.
>>>
>>> For patch1/3 I count 56/48, then for patch3 I get 48/48.  Jan, you might
>>> do the conversion to a pointer in patch1/3 to avoid bisect breakage.
>>
>> Wait, that __aligned(8) is for cb[48], not for the contents.
>>
>> For patch1/3 I count 28/48 on 32-bit, 36/48 on 64-bit (or would that be
>> 56 by default on 64-bit arches without aligned specified?), then for
>> patch3 I get 24/48 on 32 and 40/48 on 64 (or again 48/48 by default?).
>
> Do not count, just add this :
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 86de99a..5b61320 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1329,6 +1329,7 @@ static void unix_detach_fds(struct scm_cookie *scm, struct sk_buff *skb)
>   {
>   	int i;
>
> +	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof(skb->cb));
>   	scm->fp = UNIXCB(skb).fp;
>   	UNIXCB(skb).fp = NULL;
>

That's already in af_unix.c:

BUILD_BUG_ON(sizeof(struct unix_skb_parms) > FIELD_SIZEOF(struct 
sk_buff, cb));

This test is passing for me even with only patch1/3 applied when 
building 64bit kernel.

Jan Kaluza

