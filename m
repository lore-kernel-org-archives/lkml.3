Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaDUWEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:04:04 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33645 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaDUWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:03:57 -0400
Date: Mon, 21 Apr 2014 15:03:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: usage of rcu_dereference_raw
Message-ID: <20140421220352.GV4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCBrec++R-SOqHhZzNO8jimZWpEy5i-uM4UeLHG9yb-sqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBrec++R-SOqHhZzNO8jimZWpEy5i-uM4UeLHG9yb-sqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042122-6688-0000-0000-00000140B441
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 05:37:01PM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> I was trying to see the various uses of rcu_dereference_ functions to
> understand how they were being used. A doubt cropped up while doing this:
> 
> * rcu_dereference_raw(): the documentation explicitly mentions that this
>   should be minimally used as this does no checking of read critical sections
>   and does not implement barriers. But looking at the code, there are various
>   places where this is being used and it is being used I think in a buggy
>   way. For example, in drivers/net/wireless/iwlwifi/dvm/main.c, there is this:
> 
>         kfree(rcu_dereference_raw(priv->noa_data));
> 
>   I can't imagine a scenario in which this is valid. So my question is this:
>   do most of the uses of rcu_dereference_raw() need to be changed to use other
>   dereference functions or are there cases where its usage is valid?

Well, the first call to it from iwl_op_mode_dvm_start() is valid because
that field has never been exposed to readers, so that no other task or
CPU has access to this field.

The second call from iwl_op_mode_dvm_stop() -might- be valid.  For it
to be valid, there must be a grace period between the time that the
field was made inaccessible to readers and the time that iwl_uninit_drv()
was called.  Usually something like synchronize_rcu() waits for the
needed grace period.

Please let me know what you find!

							Thanx, Paul

