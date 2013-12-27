Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3L0OQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 09:16:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab3L0OQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 09:16:00 -0500
Message-ID: <52BD8B8B.1050209@redhat.com>
Date: Fri, 27 Dec 2013 15:15:39 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Gleb Natapov <gleb@kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <CAKohpomqHApogDEXA5LyWk-+B-Y1mwNQ63-wL3PPGz64s_3Dmw@mail.gmail.com> <20131227122422.62857cec@alan.etchedpixels.co.uk> <20131227124749.GE10961@minantech.com> <CA+5PVA60GSC0tTLJWLtVqb5eTPMzrszxtoBnUP8B_Q_60=oGyw@mail.gmail.com>
In-Reply-To: <CA+5PVA60GSC0tTLJWLtVqb5eTPMzrszxtoBnUP8B_Q_60=oGyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[. . .]

>> KVM does not emulate P-states at all. intel_pstate_init() calls
>> intel_pstate_msrs_not_valid() before printing "Intel P-state driver
>> initializing."  which suppose to fail since it checks that two reads of
>> MSR_IA32_APERF return different values, but KVM does not emulate this msr
>> at all, so both calls should return zero (KVM suppose to inject #GP, all rdmsrl
>> are patched to be rdmsrl_safe in a guest).
>>
>> Anything interesting in host dmesg?

Heya Gleb,

Here's the relevant dmesg snippet (full dmesg, refer the attachment below):
=====
.
.
.
[    3.462741] Intel pstate controlling: cpu 0
[    3.463972] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.465399] Intel pstate controlling: cpu 1
[    3.466505] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.468056] Intel pstate controlling: cpu 2
[    3.469208] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.470751] Intel pstate controlling: cpu 3
[    3.471870] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.473289] Intel pstate controlling: cpu 4
[    3.474545] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.475957] Intel pstate controlling: cpu 5
[    3.477135] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.478544] Intel pstate controlling: cpu 6
[    3.479670] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.481124] Intel pstate controlling: cpu 7
[    3.482288] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.483752] Intel pstate controlling: cpu 8
[    3.484986] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.486396] Intel pstate controlling: cpu 9
[    3.488000] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.489684] Intel pstate controlling: cpu 10
[    3.491027] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.492647] Intel pstate controlling: cpu 11
[    3.494026] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.495662] Intel pstate controlling: cpu 12
[    3.497065] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.498733] Intel pstate controlling: cpu 13
[    3.500071] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.501787] Intel pstate controlling: cpu 14
[    3.503105] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.504809] Intel pstate controlling: cpu 15
[    3.506142] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.507825] Intel pstate controlling: cpu 16
[    3.509175] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.510780] Intel pstate controlling: cpu 17
[    3.512158] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.513765] Intel pstate controlling: cpu 18
[    3.515225] cpufreq: __cpufreq_add_dev: ->get() failed
[    3.516898] Intel pstate controlling: cpu 19
.
.
.
=====

Full dmesg output: https://bugzilla.kernel.org/attachment.cgi?id=119701

  (Kernel bug: https://bugzilla.kernel.org/show_bug.cgi?id=67761)

>> Is it reproducible?

Yes, just now I was able to reproduce it again. It's trivial with
libguestfs-test-tool:

  $ export LIBGUESTFS_BACKEND=direct

  $ guestfish get-backend
  direct

  $ libguestfs-test-tool

You see the Kernel panic on stdout.

NOTE: You can reproduce the issue without setting LIBGUESTFS_BACKEND=direct,
      in which case, it'll default to 'libvirt' back-end.


Version:

  $ uname -r; rpm -q libguestfs libvirt qemu-system-x86
  3.13.0-0.rc4.git5.1.fc21.x86_64
  libguestfs-1.25.18-1.fc21.x86_64
  libvirt-1.1.3.1-2.fc20.x86_64
  qemu-system-x86-1.6.1-2.fc20.x86_64


> 
> Seems reproducible.  I forgot to link to the actual bug in my original
> report, but you can find it here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1046317
> 
> Adding Richard and Kashyap on CC.
> 
> josh
> 


-- 
/kashyap
