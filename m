Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3BNHNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:13:07 -0500
Received: from relay.parallels.com ([195.214.232.42]:45956 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3BNHNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:13:05 -0500
Message-ID: <511C8E50.8080007@parallels.com>
Date: Thu, 14 Feb 2013 11:12:16 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH review 52/85] sunrpc: Properly encode kuids and kgids
 in auth.unix.gid rpc pipe upcalls.
References: <87621w14vs.fsf@xmission.com> <1360777934-5663-1-git-send-email-ebiederm@xmission.com> <1360777934-5663-52-git-send-email-ebiederm@xmission.com> <20130213210545.GO14195@fieldses.org> <874nhfrjgg.fsf@xmission.com> <20130213215047.GR14195@fieldses.org> <8738wzq1z6.fsf@xmission.com> <20130213225840.GV14195@fieldses.org> <87ip5vn6iv.fsf@xmission.com>
In-Reply-To: <87ip5vn6iv.fsf@xmission.com>
Content-Type: text/plain; charset="windows-1251"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.29.37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14.02.2013 03:22, Eric W. Biederman пишет:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
>
>> On Wed, Feb 13, 2013 at 02:32:29PM -0800, Eric W. Biederman wrote:
>>> "J. Bruce Fields" <bfields@fieldses.org> writes:
>>>
>>>> On Wed, Feb 13, 2013 at 01:29:35PM -0800, Eric W. Biederman wrote:
>>>>> "J. Bruce Fields" <bfields@fieldses.org> writes:
>>>>>
>>>>>> On Wed, Feb 13, 2013 at 09:51:41AM -0800, Eric W. Biederman wrote:
>>>>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>>>>
>>>>>>> When a new rpc connection is established with an in-kernel server, the
>>>>>>> traffic passes through svc_process_common, and svc_set_client and down
>>>>>>> into svcauth_unix_set_client if it is of type RPC_AUTH_NULL or
>>>>>>> RPC_AUTH_UNIX.
>>>>>>>
>>>>>>> svcauth_unix_set_client then looks at the uid of the credential we
>>>>>>> have assigned to the incomming client and if we don't have the groups
>>>>>>> already cached makes an upcall to get a list of groups that the client
>>>>>>> can use.
>>>>>>>
>>>>>>> The upcall encodes send a rpc message to user space encoding the uid
>>>>>>> of the user whose groups we want to know.  Encode the kuid of the user
>>>>>>> in the initial user namespace as nfs mounts can only happen today in
>>>>>>> the initial user namespace.
>>>>>>
>>>>>> OK, I didn't know that.
>>>>>>
>>>>>> (Though I'm unclear how it should matter to the server what user
>>>>>> namespace the client is in?)
>>>>>
>>>>> Perhaps I have the description a little scrambled.  The short version
>>>>> is that to start I only support the initial network namespace.
>>>>>
>>>>> If I haven't succeeded it is my intent to initially limit the servers
>>>>> to the initial user namespace as well.  I should see if I can figure
>>>>> that out.
>>>>>
>>>>>>> When a reply to an upcall comes in convert interpret the uid and gid values
>>>>>>> from the rpc pipe as uids and gids in the initial user namespace and convert
>>>>>>> them into kuids and kgids before processing them further.
>>>>>>>
>>>>>>> When reading proc files listing the uid to gid list cache convert the
>>>>>>> kuids and kgids from into uids and gids the initial user namespace.  As we are
>>>>>>> displaying server internal details it makes sense to display these values
>>>>>>> from the servers perspective.
>>>>>>
>>>>>> All of these caches are already per-network-namespace.  Ideally wouldn't
>>>>>> we also like to associate a user namespace with each cache somehow?
>>>>>
>>>>> Ideally yes.  I read through the caches enough to figure out where there
>>>>> user space interfaces were, and to make certain we had conversions
>>>>> to/from kuids and kgids.
>>>>>
>>>>> I haven't looked at what user namespace makes sense for these
>>>>> caches.  For this cache my first guess is that net->user_ns
>>>>> is what we want as it will be shared by all users in network namespace I
>>>>> presume.
>>>>
>>>> Oh, I didn't know about net->user_ns--so each network namespace is
>>>> associated with a single user namespace, great, that simplifies life.
>>>> Yes, that sounds exactly right.
>>>
>>> Yes. net->user_ns is the user namespace the network namespace was
>>> created in.  And it is the user namespace that is used in test
>>> like ns_capable(net->user_ns, CAP_NET_ADMIN) to see if you are allowed
>>> to manipulate the network namespace.  So looks like exactly what we
>>> want for that cache.
>>>
>>> Could you double check my understanding of the code?
>>>
>>> I want to be certain that I can't _yet_ start an sunrpc server process
>>> outside of the initial user namespace.  While writing an earlier reply I
>>> realized that I hadn't thought about where sunrpc server processes come
>>> from.
>>>
>>> Reading through the code it looks like we can have nfs mounts outside of
>>> the initial network namespace.
>>
>> We're talking about the server side here, not the client, so I'm not
>> sure what you mean by "nfs mounts".  The nfs server does use various
>> pseudofilesystems ("proc", "nfsd"), and those can be mounted outside the
>> initial network namespace.
>
> Actually I was seeing that nfs clients were starting lockd.  So I was
> just reasoning here that anything that came from a nfs client was
> ultimately in the user namespace of that client, which is ultimately
> limited by the client out.
>
>> The server can receive rpc requests over network interfaces outside the
>> initial network namespace, sure.  The server doesn't perform mounts on
>> behalf of clients, though, it just accesses previously mounted
>> filesystems on clients' behalf.
>
> But nfsd_init_socks only creates sockets in a single network namespace,
> and today we pass only &init_net.
>
>>> But because they are mounts they are
>>> still limited to the initial user namespace.
>>
>> OK, so that's just a limitation on any mount whatsoever for now.  I'm
>> catching on, slowly, thanks!
>
> If you set in struct filesystem .fs_flags = FS_USERNS_MOUNT your
> filesystem can be mounted outside of the initial user namespace.  But
> since that takes extra work and because unprivileged users are allowed
> to create user namespaces and perform the mounts by default it is off.
>
>>> Now looking at the nfs server, seems to be hard coded to only start
>>> in the initial network namespace despite almost having support for
>>> starting in more.
>>
>> Right, Stanislav's got 4 more patches that should finish the job; see
>> http://mid.gmane.org/<20130201125210.3257.46454.stgit@localhost.localdomain>
>> and followups.  That should make it for 3.9, I just need to review
>> them....
>
> Ok that is interesting.
>
> There is an interesting corner case here where an unprivileged user
> can create a user namespace and then can create a network namespace.
> Depending on how we interpret things when Stanislaves patches reach
> there we might have to add:
>
> if (net->user_ns != &init_user_ns)
> 	-EINVAL
>
> Somewhere appropriate.
>
>>> Even more the nfs server is controlled and started through the "nfsd"
>>> filesystem.  Which has to be mounted before you can start the server.
>>> So you can only start the server through a mount in the initial user
>>> namespace.
>>
>> Yes.
>>
>>> lockd is started by either the nfs server or the nfs client.
>>>
>>> There are no other sunrpc servers in the kernel.
>>
>> There are a couple callback services on the NFS client--those should be
>> associated with nfs mounts in some obvious way.  There's a confusing ACL
>> service that's really just an appendage of NFSv2/v3 service.
>>
>> I think we're fine.
>
> Thanks.
>
>>> I think all of that is enough to reasonably claim that you can't have
>>> any sunrpc server processes outside of the initial user namespace.  But
>>> if I am wrong I would to find an appropriate spot to put in a line
>>> that says:
>>> 	 if (current_user_ns() != &init_user)
>>>           	return -ESORRY_CHARLEY;
>>
>> I think you're right.
>>
>> So for now it's safely confined to one user namespace, and I think we
>> understand approximately what to do if we want to support nfsd's in user
>> namespace in the future.  (Mainly, make sure nfsd and proc can be
>> mounted in them and then most things will be determined by the user_ns
>> of the network namespace associated with a given rpc.)
>
> For 3.9 the list of filesystems mountable outside the initial user
> namespace is: mqueuefs, tmpfs, ramfs, devpts, sysfs, and proc.
>
> I am a touch concerned about /proc/fs/nfsd/exports after my patches
> and Stanislavs patches both come in.  As I think that will allow for
> cases where net->user_ns != &init_userns.  But we can cross that bridge
> when we come to it.
>


Hmmm...
Maybe I'm missing the point of user namespaces, but since NFS kernel server
is controlled via NFSd file system write calls, maybe it would be better to add:

.fs_flags = FS_USERNS_MOUNT

to it and add check:

+	if (net->user_ns != current_user_ns())
+		return -EINVAL;

No?


> Eric
>


-- 
Best regards,
Stanislav Kinsbursky
