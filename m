Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaLOMzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:55:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaLOMzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:55:07 -0500
Date: Mon, 15 Dec 2014 14:54:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 03/18] arm64/uaccess: fix sparse errors
Message-ID: <20141215125426.GA27583@redhat.com>
References: <1418575877-21488-1-git-send-email-mst@redhat.com>
 <1418575877-21488-4-git-send-email-mst@redhat.com>
 <20141215111716.GG20738@arm.com>
 <20141215112310.GG11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215112310.GG11285@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:23:11AM +0000, Russell King - ARM Linux wrote:
> On Mon, Dec 15, 2014 at 11:17:16AM +0000, Will Deacon wrote:
> > On Sun, Dec 14, 2014 at 04:52:09PM +0000, Michael S. Tsirkin wrote:
> > > virtio wants to read bitwise types from userspace using get_user.  At the
> > > moment this triggers sparse errors, since the value is passed through an
> > > integer.
> > > 
> > > Fix that up using __force.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  arch/arm64/include/asm/uaccess.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> > > index 3bf8f4e..8d66bcf 100644
> > > --- a/arch/arm64/include/asm/uaccess.h
> > > +++ b/arch/arm64/include/asm/uaccess.h
> > > @@ -147,7 +147,7 @@ do {									\
> > >  	default:							\
> > >  		BUILD_BUG();						\
> > >  	}								\
> > > -	(x) = (__typeof__(*(ptr)))__gu_val;				\
> > > +	(x) = (__force __typeof__(*(ptr)))__gu_val;				\
> > >  } while (0)
> > >  
> > >  #define __get_user(x, ptr)						\
> > 
> > Acked-by: Will Deacon <will.deacon@arm.com>
> 
> This also means you can do stuff like:
> 
> 	u32 *p;
> 	__le32 v;
> 
> 	err = get_user(p, v);
> 
> which is not right.  Both the dereferenced pointer type and the destination
> type should be compatible, and if one is a bitwise type but the other isn't,
> that seems like a valid case to warn.

I just verified this case:
#define __force __attribute__((force))
#define __bitwise__ __attribute__((bitwise))
#define get_user(x, ptr) \
do {\
        unsigned long __gu_val = 0; \
       (x) = (__force __typeof__(*(ptr)))__gu_val;  \
} while (0)

typedef unsigned u32;
typedef u32 __bitwise__ __le32;

static u32 *p;
static __le32 v;


int main(int argc, char **argv)
{
        get_user(v, p);
        return 0;
}


Produces a warning as expected.

So I think the above comment is a result of a mistake.
Can you confirm please?



> I don't see any use of get_user() in drivers/virtio in mainline, so I can't
> check further.


this is an example of the case which I'm fixing:

#define __force __attribute__((force))
#define __bitwise__ __attribute__((bitwise))
#define get_user(x, ptr) \
do {\
        unsigned long __gu_val = 0; \
       (x) = (__typeof__(*(ptr)))__gu_val;  \
} while (0)

typedef unsigned u32;
typedef u32 __bitwise__ __le32;

static __le32 *p;
static __le32 v;


int main(int argc, char **argv)
{
        get_user(v, p);
        return 0;
}

the code is correct but produces a warning:
a.c:18:9: warning: cast to restricted __le32


The cast near __typeof__ above needs __force,
this is what my patch does.



> -- 
> FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
> according to speedtest.net.
