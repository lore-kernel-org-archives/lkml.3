Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaKSTvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:51:47 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:35445 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756385AbaKSTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:51:44 -0500
From: Joe Stringer <joestringer@nicira.com>
To: Pravin Shelar <pshelar@nicira.com>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: Fix mask generation for IPv6 labels.
Date: Wed, 19 Nov 2014 11:51:39 -0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1416336857-61405-1-git-send-email-joestringer@nicira.com> <201411190948.11857.joestringer@nicira.com> <CALnjE+pQnUGiiuWPGt7fNnBetwdn7SQReDqCHDforX7ykQQR8Q@mail.gmail.com>
In-Reply-To: <CALnjE+pQnUGiiuWPGt7fNnBetwdn7SQReDqCHDforX7ykQQR8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201411191151.40064.joestringer@nicira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 19, 2014 11:08:35 Pravin Shelar wrote:
> On Wed, Nov 19, 2014 at 9:48 AM, Joe Stringer <joestringer@nicira.com> 
wrote:
> > On Wednesday, November 19, 2014 00:11:01 Pravin Shelar wrote:
> >> On Tue, Nov 18, 2014 at 11:25 PM, Joe Stringer <joestringer@nicira.com>
> > 
> > wrote:
> >> > On 18 November 2014 22:09, Pravin Shelar <pshelar@nicira.com> wrote:
> >> >> On Tue, Nov 18, 2014 at 10:54 AM, Joe Stringer
> >> >> <joestringer@nicira.com>
> >> >> 
> >> >> wrote:
> >> >> > When userspace doesn't provide a mask, OVS datapath generates a
> >> >> > fully unwildcarded mask for the flow. This is done by taking a
> >> >> > copy of the flow key, then iterating across its attributes,
> >> >> > setting all values to 0xff. This works for most attributes, as the
> >> >> > length of the netlink attribute typically matches the length of
> >> >> > the value. However, IPv6 labels only use the lower 20 bits of the
> >> >> > field. This patch makes a special case to handle this.
> >> >> > 
> >> >> > This fixes the following error seen when installing IPv6 flows
> >> >> > without a mask:
> >> >> > 
> >> >> > openvswitch: netlink: Invalid IPv6 flow label value
> >> >> > (value=ffffffff, max=fffff)
> >> >> 
> >> >> We should allow exact match mask here rather than generating
> >> >> wildcarded mask. So that ovs can catch invalid ipv6.label.
> >> > 
> >> > I don't quite follow, I thought this was exact-match? (The existing
> >> > function sets all bits to 1)
> >> 
> >> With 0xffffffff value we can exact match on all ipv6.lable bits.
> > 
> > The label field is only 20 bits. The other bits in the same word of the
> > IPv6 header are for version (fixed) and traffic class (handled
> > separately). We don't do anything with the other bits.
> 
> This is just to make sure that we do not use those field for any thing
> else. Masking those extra bits can hide incorrect ipv6 key extraction.

Oh, I see. I meant something more like:

ipv6_key->ipv6_label &= htonl(0xFFF00000);
ipv6_key->ipv6_label |= htonl(0x000FFFFF);

(Which would propagate the invalid bits from the flow key, but actually produce 
an exact match).
