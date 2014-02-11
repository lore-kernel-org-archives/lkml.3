Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaBKRxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:53:04 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60544 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaBKRxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:53:01 -0500
Date: Tue, 11 Feb 2014 11:52:32 -0600
From: Calvin Owens <jcalvinowens@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ieee80211: Print human-readable disassoc/deauth
 reason codes
Message-ID: <20140211175232.GA782@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
 <1391661863.30094.56.camel@joe-AO722>
 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
 <1392050359.2507.10.camel@joe-AO722>
 <20140211012523.GA2739@gmail.com>
 <1392082740.2507.49.camel@joe-AO722>
 <20140211163738.GA32043@gmail.com>
 <1392138837.2511.2.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1392138837.2511.2.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02/11 at 09:13 -0800, Joe Perches wrote:
> On Tue, 2014-02-11 at 10:37 -0600, Calvin Owens wrote:
> > Create a function to return a descriptive string for each reason code,
> > and print that in addition to the numeric value in the kernel log. These
> > codes are easily found on popular search engines, but one is generally
> > not able to access the internet when dealing with wireless connectivity
> > issues.
> []
> >  include/net/mac80211.h | 10 +++++++++
> >  net/mac80211/main.c    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  net/mac80211/mlme.c    | 12 +++++------
> >  3 files changed, 73 insertions(+), 6 deletions(-)
> 
> Is there a reason why all of this this shouldn't
> be a static function local to mlme.c?
> 
> Is this ever going to be used somewhere else?

The enum for the reason code is defined in "include/linux/ieee80211.h",
which is #include'd in 61 different files, so I thought it was
conceivable that it might. I also thought the compiler wasn't likely to
inline it even if it were static, since it wasn't tiny and had several
callers.

The switch statement approach produces nice, smaller code though:
(as opposed to the original with the array of strings)

ffffffff81728ac0 <ieee80211_get_reason_code_string>:
ffffffff81728ac0:       83 ef 01                sub    $0x1,%edi
ffffffff81728ac3:       55                      push   %rbp
ffffffff81728ac4:       48 c7 c0 f5 a7 a6 81    mov    $0xffffffff81a6a7f5,%rax
ffffffff81728acb:       66 83 ff 41             cmp    $0x41,%di
ffffffff81728acf:       48 89 e5                mov    %rsp,%rbp
ffffffff81728ad2:       77 0b                   ja     ffffffff81728adf <ieee80211_get_reason_code_string+0x1f>
ffffffff81728ad4:       0f b7 ff                movzwl %di,%edi
ffffffff81728ad7:       48 8b 04 fd 40 98 8e    mov -0x7e7167c0(,%rdi,8),%rax
ffffffff81728ade:       81 
ffffffff81728adf:       5d                      pop    %rbp
ffffffff81728ae0:       c3                      retq   
ffffffff81728ae1:       66 66 66 66 66 66 2e    data32 data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
ffffffff81728ae8:       0f 1f 84 00 00 00 00 
ffffffff81728aef:       00 

... so it probably would get inlined. I'll make it static and resend.

Thanks,
Calvin
