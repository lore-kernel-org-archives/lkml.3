Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JBWX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 18:23:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57574 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab3JBWX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 18:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <CABfLueFJWv0OvcDmP7TMTF4wHjjv5QW_Qt+ULSDBciX==HsXQw@mail.gmail.com>
References: <CABfLueFJWv0OvcDmP7TMTF4wHjjv5QW_Qt+ULSDBciX==HsXQw@mail.gmail.com>
Date: Wed, 2 Oct 2013 23:23:26 +0100
Message-ID: <CABfLueH2EQ9tY9hDHOkoN9Ps8sj8T23M5noF7-EMOEpt3UFNMg@mail.gmail.com>
Subject: Fwd: The check of upper MTU limit when changing it in ip6 gre tunnel
 seems incorrect.
From: Oussama Ghorbel <ou.ghorbel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check of upper MTU limit when changing it in ip6 gre tunnel seems incorrect.
The function in question is:

static int ip6gre_tunnel_change_mtu(struct net_device *dev, int new_mtu)
{
    struct ip6_tnl *tunnel = netdev_priv(dev);

    if (new_mtu < 68 ||
        new_mtu > 0xFFF8 - dev->hard_header_len - tunnel->hlen)
        return -EINVAL;
    dev->mtu = new_mtu;
    return 0;
}

However the dev->hard_header_len and tunnel->hlen are initialized in
the following way in ip6gre_tnl_link_config():

int addend = sizeof(struct ipv6hdr) + 4;
...
dev->hard_header_len = rt->dst.dev->hard_header_len + addend;
...
t->hlen = addend; // t is ip6_tnl pointer

As you see the information t->hlen is already included in
dev->hard_header_len, so why calculate it twice?

Thanks
