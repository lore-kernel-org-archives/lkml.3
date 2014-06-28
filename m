Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaF1QUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 12:20:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaF1QUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 12:20:21 -0400
Date: Sat, 28 Jun 2014 12:20:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kiran Kankipati <kiran.kankipati@gmail.com>
Cc: "Don A. Bailey" <donb@securitymouse.com>, linux-kernel@vger.kernel.org
Subject: Re: Bug in Kernel's LZ4-HC in 64bit (kernel crypto library)
Message-ID: <20140628162009.GA13161@kroah.com>
References: <CALWnrFRO_trdJ7aL_vaWtFbdJgxRkt4+zROR_chQFNPz7v3BVQ@mail.gmail.com>
 <20140628160020.GA11019@kroah.com>
 <CALWnrFRQ_VHzPtBe04n3xfeQu=kjw=TE+wotzyoTW5P6gdZ-zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALWnrFRQ_VHzPtBe04n3xfeQu=kjw=TE+wotzyoTW5P6gdZ-zQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 09:39:12PM +0530, Kiran Kankipati wrote:
> Wow I see. Thanks Greg. I seen the 3.15.2 change logs, found you are involved
> in the LZO issue.
> 
> I read about this issue in some news too that they found 20yr old bug in it.
> 
> So thought reporting to you via email.
> 
> I don't do bugzilla :)
> >> I see.
> 
> I am new to kernel foundation procedures. So sorry for bothering you.
> 
> --------
> Ok, where do you see an overrun happening?  I know the lz4 code in the
> kernel is "old" compared to upstream.  I am working on updating it to
> the latest version, but that's not going to happen until 3.17.
> 
> >> Here is the place and APIs I am using in my TrafficSqueezer code:
> 
> 
> void ts_comp(BYTE *flag, BYTE *pbuff, size_t *pbuff_len, BYTE *mid_buff, BYTE
> *lz4hc_wrkmem)
> {    size_t mid_buff_size = 0;
> 
>     if(lz4hc_compress( (const unsigned char *)pbuff, (*pbuff_len), (unsigned
> char *)mid_buff, &mid_buff_size, (void *)lz4hc_wrkmem)<0) return;
>        
>     if(((mid_buff_size+TS_FLAG_SIZE) < (*pbuff_len)) && (mid_buff_size!=0))
>     {    memcpy((BYTE *)pbuff, (BYTE *)mid_buff, mid_buff_size); (*pbuff_len)=
> mid_buff_size;
>         ts_set_pkt_tag(flag, TS_FLAG_COMP);
>         #ifdef CONFIG_TRAFFICSQUEEZER_DEBUG
>         printk("comp - prossd [LZ4-HC] [mid_buff_size: %zu]\n", mid_buff_size);
>         #endif
>     }
> }
> 
> bool ts_decomp(BYTE *pbuff, size_t *pbuff_len, BYTE *mid_buff)
> {  size_t mid_buff_size = TS_MAX_OPT_BUF_LEN;  //WARNING: DO NOT change this !!
> 
>     if(lz4_decompress_unknownoutputsize( (const unsigned char *)pbuff,
> (*pbuff_len), (unsigned char *)mid_buff,  &mid_buff_size)<0) { return false; }
>     if(mid_buff_size > TS_MAX_OPT_BUF_LEN) { return false; }
>    
>     memcpy((BYTE *)pbuff, (BYTE *)mid_buff, mid_buff_size); (*pbuff_len)=
> mid_buff_size;
> #ifdef CONFIG_TRAFFICSQUEEZER_DEBUG
>     printk("decomp - prossd [LZ4-HC] [mid_buff_size: %zu]\n", mid_buff_size);
> #endif  
>     return true;
> }

I don't understand, are you having problems on the compress side, or the
decompress side?  Where in the lz4 is a bug happening?

Do you have a data stream that I can use to run it through the lz4 code
to see where the problem is in the compress/decompress code?

> ------------
> If this fix scheduled for 3.17, I am glad enough to wait till then. Since I
> need this fix as a part of mainstream kernel release series :)

The fixes I've done will show up in 3.16-rc3 and in the next round of
stable kernel updates that will come out Monday, so you can pick those
releases up and test if you can't apply individual patches for a kernel
tree.

thanks,

greg k-h
