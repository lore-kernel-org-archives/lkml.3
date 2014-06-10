Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaFJLut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:50:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60919 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaFJLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:50:47 -0400
Date: Tue, 10 Jun 2014 13:50:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Bisecting the heisenbugs (was Re: 3.15-rc: regression in suspend)
Message-ID: <20140610115045.GA6019@amd.pavel.ucw.cz>
References: <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
 <20140514155759.GB9723@amd.pavel.ucw.cz>
 <20140514182046.GA13342@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1405151727380.16459@pobox.suse.cz>
 <CAKMK7uFEjDGSpdB0xDPL09GZ8N7aFrNA530HbRLyfTPx5SkLQw@mail.gmail.com>
 <20140607120614.GB5309@amd.pavel.ucw.cz>
 <20140607231124.GA3611@amd.pavel.ucw.cz>
 <CAKMK7uEALofLiEA3m-QKjygC=YZNjaEtUMfbpbXinMoim1ygkw@mail.gmail.com>
 <20140609102328.GA25332@amd.pavel.ucw.cz>
 <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 2014-06-09 13:03:31, Jiri Kosina wrote:
> On Mon, 9 Jun 2014, Pavel Machek wrote:
> 
> > > > Strange. It seems 3.15 with the patch reverted only boots in 30% or so
> > > > cases... And I've seen resume failure, too, so maybe I was just lucky
> > > > that it worked for a while.
> > > 
> > > git bisect really likes 25f397a429dfa43f22c278d0119a60 - you're about
> > > the 5th report or so that claims this is the culprit but it's
> > > something else. The above code is definitely not used in i915 so bogus
> > > bisect result.
> > 
> > Note I did not do the bisect, I only attempted revert and test.
> > 
> > And did three boots of successful s2ram.. only to find out that it
> > does not really fix s2ram, I was just lucky :-(.
> > 
> > Unfortunately, this means my s2ram problem will be tricky/impossible
> > to bisect :-(.
> 
> Welcome to the situation I have been in for past several months.

I attempted to do some analysis. It should be possible to bisect when
tests are not reliable, but it will take time and it will be almost
neccessary to have the bisection automated.

How long does the testing take for you to get to 50% test reliability?

It seems to be one minute here.

Trivial strategy is to repeat each test to get to 99% test
reliability. That should make the test about 2x longer.

There are other strategies possible -- like selecting bisect points
closer to the "bad" end, and tricky "lets compute probabilities for
each point", that work well for some parameter settings. There is
probably even better strategy possible... if you have an idea, you can
try it below.

Monte carlo simulation is attached. 

Bisector on reliable bug
-----
1024 versions bug with probability of  0  false success, monte carlo
of  30000  tries
Assume compilation takes  6 minutes and test takes 1 minutes
Average cost  71.0522 minutes
Average tests  9.99793333333
Bisector
-----
1024 versions bug with probability of  0.5  false success, monte carlo
of  30000  tries
Assume compilation takes  6 minutes and test takes 1 minutes
Average cost  143.393933333 minutes
Average tests  44.5374666667
Trisector
-----
1024 versions bug with probability of  0.5  false success, monte carlo
of  30000  tries
Assume compilation takes  6 minutes and test takes 1 minutes
Average cost  160.554 minutes
Average tests  39.9552666667
Strange
-----
1024 versions bug with probability of  0.5  false success, monte carlo
of  3000  tries
Assume compilation takes  6 minutes and test takes 1 minutes
Average cost  246.658 minutes
Average tests  38.412
pavel@amd:~/WWW$ 


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--k+w/mQv8wyuph6w0
Content-Type: text/x-python; charset=us-ascii
Content-Disposition: attachment; filename="tricky_bisect.py"

#!/usr/bin/python

import random
import numpy

class Devil:
    def init(m):
        m.versions = 1024
        # Costs in minutes
        m.cost_compile = 6
        m.cost_test = 1
        # Penalty for wrongly identifying a commit.
        m.cost_failure = 1000
        # 0. == nicely behaved bug which always triggers
        m.p_false_success = .5
        m.verbose = 2

    def init_run(m):
        m.broken = random.randint(0, m.versions-1)
        m.tests = 0
        m.last_ver = -1
        m.cost = 0

    def test_failed(m, ver):
        m.tests += 1
        if ver != m.last_ver:
            m.cost += m.cost_compile
        m.cost += m.cost_test
        m.last_ver = ver
        if m.verbose > 1:
            print "   testing version ", ver, "(tests %d, cost %d)" % (m.tests, m.cost),
        if ver >= m.broken:
            if m.verbose > 1:
                print "(bad)",
            if random.random() > m.p_false_success:
                if m.verbose > 1:
                    print "FAIL"
                return 1
        if m.verbose > 1:
            print "pass"
        return 0

    def evaluate(m):
        ver = m.run()
        if ver == m.broken:
            if m.verbose:
                print "success"
        else:
            if m.verbose:
                print "FAILURE"
            m.cost += m.cost_failure

class Bisector(Devil):
    def init_run(m):
        Devil.init_run(m)
        m.good = 0
        m.bad = m.versions-1

    def run(m):
        while m.good+1 < m.bad:
            ver = (m.good + m.bad) / 2
            p_bad = 1
            failed = 0
            while p_bad > .01:
                if m.test_failed(ver):
                    m.bad = ver
                    failed = 1
                    break
                p_bad *= m.p_false_success
            if not failed:
                m.good = ver
        return m.bad

class Trisector(Devil):
    def init_run(m):
        Devil.init_run(m)
        m.good = 0
        m.bad = m.versions-1

    def run(m):
        while m.good+1 < m.bad:
            ver = (m.good*6 + m.bad*14) / 20
            p_bad = 1
            failed = 0
            while p_bad > .01:
                if m.test_failed(ver):
                    m.bad = ver
                    failed = 1
                    break
                p_bad *= m.p_false_success
            if not failed:
                m.good = ver
        return m.bad


class Strange(Devil):
    def init_run(m):
        Devil.init_run(m)
        m.good = 0
        m.bad = m.versions-1
        m.prob_bad = numpy.zeros([m.versions], float)
        m.prob_bad[:m.versions] = .9

    def ask_for(m, ver):
        if m.test_failed(ver):
            m.bad = ver
            m.prob_bad[:ver+1] /= m.prob_bad[ver]
            m.prob_bad[ver:] = 1
            return

        m.prob_bad[:ver+1] *= m.p_false_success
        m.good = ver

    def last_good(m, prob):
        g = 0
        for i in range(m.bad):
            if m.prob_bad[i] <= prob:
                g = i
        return g

    def run(m):

        while m.last_good(.01)+1 < m.bad:
            if m.verbose > 1:
                print m.prob_bad
            m.good = m.last_good(.5)
            ver = (m.good*10 + m.bad*10) / 20
            m.ask_for(ver)
            m.good = m.last_good(.1)
            ver = (m.good*10 + m.bad*10) / 20
            m.ask_for(ver)


        return m.bad

def monte_carlo(bis, tries = 30000):
    total_cost = 0.
    total_tests = 0.
    for i in range(tries):
        bis.init_run()
        if tries > 500:
            bis.verbose = 0
        bis.evaluate()
        total_cost += bis.cost
        total_tests += bis.tests

    print "-----"
    print bis.versions, "versions bug with probability of ", bis.p_false_success, " false success, monte carlo of ", tries, " tries"
    print "Assume compilation takes ", bis.cost_compile, "minutes and test takes", bis.cost_test, "minutes"
    print "Average cost ", total_cost / tries, "minutes"
    print "Average tests ", total_tests / tries

print "Bisector on reliable bug"
bis = Bisector()
bis.init()
bis.p_false_success = 0
monte_carlo(bis)

print "Bisector"
bis = Bisector()
bis.init()
monte_carlo(bis)

print "Trisector"
bis = Trisector()
bis.init()
monte_carlo(bis)

print "Strange"
bis = Strange()
bis.init()
monte_carlo(bis, 3000)





--k+w/mQv8wyuph6w0--
