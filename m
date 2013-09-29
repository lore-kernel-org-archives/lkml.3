Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3I2Jgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 05:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab3I2Jgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:36:33 -0400
Message-ID: <5247F49B.2020104@redhat.com>
Date: Sun, 29 Sep 2013 17:36:27 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/6] vhost_net: determine whether or not to use zerocopy
 at one time
References: <1378111261-14826-1-git-send-email-jasowang@redhat.com> <1378111261-14826-5-git-send-email-jasowang@redhat.com> <20130904115929.GA9393@redhat.com> <5227F274.9040506@redhat.com> <20130923071620.GB31886@redhat.com> <5243B859.3070302@redhat.com>
In-Reply-To: <5243B859.3070302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 12:30 PM, Jason Wang wrote:
> On 09/23/2013 03:16 PM, Michael S. Tsirkin wrote:
>> > On Thu, Sep 05, 2013 at 10:54:44AM +0800, Jason Wang wrote:
>>>> >> > On 09/04/2013 07:59 PM, Michael S. Tsirkin wrote:
>>>>>> >>> > > On Mon, Sep 02, 2013 at 04:40:59PM +0800, Jason Wang wrote:
>>>>>>>> >>>> > >> Currently, even if the packet length is smaller than VHOST_GOODCOPY_LEN, if
>>>>>>>> >>>> > >> upend_idx != done_idx we still set zcopy_used to true and rollback this choice
>>>>>>>> >>>> > >> later. This could be avoided by determining zerocopy once by checking all
>>>>>>>> >>>> > >> conditions at one time before.
>>>>>>>> >>>> > >>
>>>>>>>> >>>> > >> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>>>>> >>>> > >> ---
>>>>>>>> >>>> > >>  drivers/vhost/net.c |   47 ++++++++++++++++++++---------------------------
>>>>>>>> >>>> > >>  1 files changed, 20 insertions(+), 27 deletions(-)
>>>>>>>> >>>> > >>
>>>>>>>> >>>> > >> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>>>>>>>> >>>> > >> index 8a6dd0d..3f89dea 100644
>>>>>>>> >>>> > >> --- a/drivers/vhost/net.c
>>>>>>>> >>>> > >> +++ b/drivers/vhost/net.c
>>>>>>>> >>>> > >> @@ -404,43 +404,36 @@ static void handle_tx(struct vhost_net *net)
>>>>>>>> >>>> > >>  			       iov_length(nvq->hdr, s), hdr_size);
>>>>>>>> >>>> > >>  			break;
>>>>>>>> >>>> > >>  		}
>>>>>>>> >>>> > >> -		zcopy_used = zcopy && (len >= VHOST_GOODCOPY_LEN ||
>>>>>>>> >>>> > >> -				       nvq->upend_idx != nvq->done_idx);
>>>>>>>> >>>> > >> +
>>>>>>>> >>>> > >> +		zcopy_used = zcopy && len >= VHOST_GOODCOPY_LEN
>>>>>>>> >>>> > >> +				   && (nvq->upend_idx + 1) % UIO_MAXIOV !=
>>>>>>>> >>>> > >> +				      nvq->done_idx
>>>>>> >>> > > Thinking about this, this looks strange.
>>>>>> >>> > > The original idea was that once we start doing zcopy, we keep
>>>>>> >>> > > using the heads ring even for short packets until no zcopy is outstanding.
>>>> >> > 
>>>> >> > What's the reason for keep using the heads ring?
>> > To keep completions in order.
> Ok, I will do some test to see the impact.

Since the our of order completion will happen when switching between
zero copy and non zero copy. I test this by using two sessions of
netperf in burst mode, one with 1 byte TCP_RR another with 512 bytes of
TCP_RR. There's no difference with the patch applied.

