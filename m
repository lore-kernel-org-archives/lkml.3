Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbaJ1E1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:27:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51478 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaJ1E06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:26:58 -0400
Date: Mon, 27 Oct 2014 21:11:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [GIT PULL] overlay filesystem v25
Message-ID: <20141028041127.GM5718@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141024032422.GI7996@ZenIV.linux.org.uk>
 <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
 <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
 <20141025170609.GK7996@ZenIV.linux.org.uk>
 <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
 <20141027155901.GE5718@linux.vnet.ibm.com>
 <20141027172800.GW7996@ZenIV.linux.org.uk>
 <20141027173621.GG5718@linux.vnet.ibm.com>
 <20141028011214.GZ7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028011214.GZ7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102804-0033-0000-0000-0000027C56B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:12:14AM +0000, Al Viro wrote:
> On Mon, Oct 27, 2014 at 10:36:21AM -0700, Paul E. McKenney wrote:
> > Code making direct use of smp_read_barrier_depends() is harder to read,
> > in my experience, but good point on the sparse noise.  Maybe a new
> > lockless_dereference() primitive?  Maybe something like the following?
> > (Untested, probably does not even build.)
> > 
> > #define lockless_dereference(p) \
> > ({ \
> > 	typeof(*p) *_________p1 = ACCESS_ONCE(p); \
> > 	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
> > 	_________p1; \
> > })
> 
> Hmm...  Where would you prefer to put it?  rcupdate.h?

Good a place as any, I guess.  Please see patch below.  Left to myself,
I would send this along for the next merge window, but please let me
know if you would like it sooner.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Provide counterpart to rcu_dereference() for non-RCU situations

Although rcu_dereference() and friends can be used in situations where
object lifetimes are being managed by something other than RCU, the
resulting sparse and lockdep-RCU noise can be annoying.  This commit
therefore supplies a lockless_dereference(), which provides the
protection for dereferences without the RCU-related debugging noise.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9575c2d403b5..ed4f5939a452 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -617,6 +617,21 @@ static inline void rcu_preempt_sleep_check(void)
 #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
 
 /**
+ * lockless_dereference() - safely load a pointer for later dereference
+ * @p: The pointer to load
+ *
+ * Similar to rcu_dereference(), but for situations where the pointed-to
+ * object's lifetime is managed by something other than RCU.  That
+ * "something other" might be reference counting or simple immortality.
+ */
+#define lockless_dereference(p) \
+({ \
+	typeof(p) _________p1 = ACCESS_ONCE(p); \
+	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
+	(_________p1); \
+})
+
+/**
  * rcu_assign_pointer() - assign to RCU-protected pointer
  * @p: pointer to assign to
  * @v: value to assign (publish)

