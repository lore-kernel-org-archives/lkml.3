Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbbAFRg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:36:59 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63877 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbAFRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:36:56 -0500
MIME-Version: 1.0
In-Reply-To: <54ABE991.3040107@mellanox.com>
References: <1420512850-24699-1-git-send-email-ddecotig@gmail.com> <54ABE991.3040107@mellanox.com>
From: David Decotigny <ddecotig@gmail.com>
Date: Tue, 6 Jan 2015 09:36:36 -0800
X-Google-Sender-Auth: AWwNXY_5nYBbYVeXTztMWyBe6Uw
Message-ID: <CAG88wWYPDpwkWkL+Pj2VKrX5WVp=at8v0=gcFAVAA8nntv+-nw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/8] net: extend ethtool link mode bitmaps to
 48 bits
To: Amir Vadai <amirv@mellanox.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Ben Hutchings <ben@decadent.org.uk>,
        Masatake YAMATO <yamato@redhat.com>, Xi Wang <xii@google.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tom Gundersen <teg@jklm.no>, Jiri Pirko <jiri@resnulli.us>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@emulex.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting. It seems that the band-aid I was proposing is already
obsolete. We could still use the remaining reserved 16 bits to encode
5 more bits per mask (that is: 53 bits / mask total). But if I
understand you, it would allow us to survive only a few months longer,
as opposed to a few weeks.

One short-term alternative solution I can imagine is the following:
/* For example bitmap-based for variable length: */
struct ethtool_link_mode {
  __u32 cmd;
  __u8 autoneg :1;
  __u8 duplex :2;
 __u16 supported_nbits;
  __u16 advertising_nbits;
  __u16 lp_advertising_nbits;
  __u32 reserved[4];
  __u8 masks[0];
};
/* Or simpler, statically limited to 64b / mask, but easier to migrate
to for driver authors: */
struct ethtool_link_mode {
  __u32 cmd;
  __u8 autoneg :1;
  __u8 duplex :2;
   __u64 supported;
  __u64 advertising;
  __u64 lp_advertising;
  __u32 reserved[4];
};
#define ETHTOOL_GLINK_MODE 0x0000004a
#define ETHTOOL_SLINK_MODE 0x0000004b
struct ethtool_ops {
...
   int (*get_link_mode)(struct net_device *, struct ethtool_link_mode *);
   int (*set_link_mode)(struct net_device *, struct ethtool_link_mode *);
};

The same thing required for EEE.

I am not sure about moving the autoneg and duplex fields into the new
struct. Especially the "duplex" field.

Then the idea would be to update the ethtool user-space tool to try
get/set_link mode when reporting/changing the autoneg/advertising
settings.

Both will require significant effort from the driver authors.
Especially if the variable-length bitmap approach is preferred:
 - most drivers currently use simple bitwise arithmetic in their code,
and that goes far beyond get/set_settings, it is sometimes part of the
core driver logic. They will have to migrate to the bitmap API if they
want to use the larger bitmaps (note: no change needed if they are
happy with <= 32b / mask)
 - we would have to progressively deprecate the use of #define
ADVERTISED_1000baseT_Full in favor of an enum of the bit indices.

Any feedback welcome. In the meantime, I am going to propose a v3 of
current option with 53 bits / mask. I can also propose a prototype of
the scheme described above, please let me know.

On Tue, Jan 6, 2015 at 5:56 AM, Amir Vadai <amirv@mellanox.com> wrote:
> On 1/6/2015 4:54 AM, David Decotigny wrote:
>> This patch series increases the width of the supported/advertising
>> ethtool masks from 32 bits to 48. This should allow to breathe for a
>> couple more years (or... months?).
> Hi,
>
> Nice work.
> What worries me is that it is going to be for weeks more than years or
> months...
>
> Mellanox is about to release next month a driver for a new NIC, with 3
> new speeds * few link modes for each + new link modes for 10G.
> It seems that we will need to consume almost all the new bits.
>
> Amir
