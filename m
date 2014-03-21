Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbaCULG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:06:26 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:22608 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759943AbaCULGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:06:24 -0400
Date: Fri, 21 Mar 2014 11:05:59 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>
Subject: Re: [PATCH V4 1/3] cpufreq: Make sure frequency transitions are
 serialized
Message-ID: <20140321110559.GB13596@arm.com>
References: <cover.1395379422.git.viresh.kumar@linaro.org>
 <f6116069b730c0c3a74ff627fa818b98dc4f1491.1395379422.git.viresh.kumar@linaro.org>
 <532BEE64.3090501@linux.vnet.ibm.com>
 <CAKohpom8ZHXxVmuSHYL5nyZzNrK8EFNVdx5XJdJxiHWPb13aeg@mail.gmail.com>
 <532BFB77.5060107@linux.vnet.ibm.com>
 <CAKohpomY4xf4tOFTGt-ykE7sUi4ks7vW5qp8ytgopm6CiY9QRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomY4xf4tOFTGt-ykE7sUi4ks7vW5qp8ytgopm6CiY9QRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 09:21:02AM +0000, Viresh Kumar wrote:
> @Catalin: We have a problem here and need your expert advice. After changing
> CPU frequency we need to call this code:
> 
> cpufreq_notify_post_transition();
> policy->transition_ongoing = false;
> 
> And the sequence must be like this only. Is this guaranteed without any
> memory barriers? cpufreq_notify_post_transition() isn't touching
> transition_ongoing at all..

The above sequence doesn't say much. As rmk said, the compiler wouldn't
reorder the transition_ongoing write before the function call. I think
most architectures (not sure about Alpha) don't do speculative stores,
so hardware wouldn't reorder them either. However, other stores inside
the cpufreq_notify_post_transition() could be reordered after
transition_ongoing store. The same for memory accesses after the
transition_ongoing update, they could be reordered before.

So what we actually need to know is what are the other relevant memory
accesses that require strict ordering with transition_ongoing.

What I find strange in your patch is that
cpufreq_freq_transition_begin() uses spinlocks around transition_ongoing
update but cpufreq_freq_transition_end() doesn't.

-- 
Catalin
